echo "    IdentityFile ~/.ssh/id_rsa" >> /etc/ssh/ssh_config

cat <<EOF >$HOME/.aws/credentials
[default]
aws_access_key_id = ${AWS_ACCESS_KEY}
aws_secret_access_key = ${AWS_SECRET_ACCESS_KEY}
EOF

cat <<EOF >$HOME/.aws/config
[default]
output = json
region = us-west-2
EOF

source /env/bin/activate
python webhooks.py
