FROM picorb/python
MAINTAINER "Laurent Rineau" <laurent.rineau@cgal.org>

RUN apt-get update --fix-missing
RUN apt-get install -y ansible

# Cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN apt-get autoremove -y

ADD LICENSE requirements.txt webhooks.py config.json hooks /src/

WORKDIR /src
RUN pip install -r requirements.txt

EXPOSE 5000

CMD ["sh", "run.sh"]
