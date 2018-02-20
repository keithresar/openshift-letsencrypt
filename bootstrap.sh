

# create global template
oc create -f template.yaml -n openshift

# create project
oc new-project letsencrypt

# register letsencrypt user id
brew install dehydrated
echo CONTACT_EMAIL=${EMAIL} > my_config
dehydrated -f my_config --register --accept-terms

# create secret
oc create secret generic letsencrypt-creds \
     --from-file=account-key=`find ~/rht-ansible/openshiftdelivers/ocp_letsencrypt/files/letsencrypt_key_*.pem`

# Add permissions to the letsencrypt user we just created
oc create -f letsencrypt-clusterrole.yaml


# create app in our current project
oc new-app --template=letsencrypt -p LETSENCRYPT_CONTACT_EMAIL=${EMAIL}

oc adm policy add-cluster-role-to-user cluster-admin system:serviceaccount:test2:letsencrypt


