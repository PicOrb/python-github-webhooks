FROM picorb/python
MAINTAINER "Laurent Rineau" <laurent.rineau@cgal.org>

RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN add-apt-repository ppa:ansible/ansible
RUN apt-get update --fix-missing
RUN apt-get install -y ansible rsync
RUN ansible-galaxy install defunctzombie.coreos-bootstrap

# Cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN apt-get autoremove -y

ADD https://raw.githubusercontent.com/ansible/ansible/release1.8.2/plugins/inventory/ec2.py /etc/ansible/
ADD https://raw.githubusercontent.com/ansible/ansible/release1.8.2/plugins/inventory/ec2.ini /etc/ansible/
RUN chmod u+x /etc/ansible/ec2.py

RUN virtualenv /env
RUN source /env/bin/activate
ADD requirements.txt /src/
RUN /env/bin/pip install -U pip
RUN /env/bin/pip install -r /src/requirements.txt
ADD . /src/

WORKDIR /src
RUN ssh-keygen -n ericson@picorb.com -f ./id_rsa -C "ericson@picorb.com" -q -N ''
RUN eval `ssh-agent -s` && \
    ssh-add id_rsa && \
    ssh-keyscan -t rsa github.com > ~/.ssh/known_hosts && \
    git clone https://github.com/PicOrb/ansible-plugins.git /usr/share/ansible_plugins && \
    mkdir /usr/share/ansible_plugins/callback_plugins && \
    \
    curl -o /usr/share/ansible_plugins/callback_plugins/profile_tasks.py https://raw.githubusercontent.com/jlafon/ansible-profile/master/callback_plugins/profile_tasks.py
    #git clone git@github.com:Twnel/infrastructure.git


RUN mv /src/cfg/* /etc/ansible/

ENV EC2_INI_PATH /etc/ansible/ec2.ini
ENV ANSIBLE_INVENTORY /etc/ansible/ec2.py
ENV ANSIBLE_CONFIG /etc/ansible/ansible.cfg

RUN mkdir /root/.aws
VOLUME ['/root/.aws']

EXPOSE 5000

CMD ["sh", "run.sh"]
