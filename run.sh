echo "    IdentityFile ~/.ssh/id_rsa" >> /etc/ssh/ssh_config
git clone git@github.com:Twnel/infrastructure.git
python webhooks.py
