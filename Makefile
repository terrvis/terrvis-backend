.PHONEY: terrvis_backend
terrvis_backend:
	bash ./bin/terrvis_backend.sh

.PHONEY: terrvis_tfvars
terrvis_tfvars:
	bash ./bin/terrvis_tfvars.sh

.PHONEY: terrvis_user_id
terrvis_user_id:
	cd terrvis_deploy ; terraform output aws_access_id ; cd -

.PHONEY: terrvis_user_key
terrvis_user_key:
	cd terrvis_deploy ; terraform output aws_secret_key | base64 --decode | keybase pgp decrypt ; cd -
