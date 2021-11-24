# Path to your oh-my-zsh installation.
export ZSH=/home/kalen/.oh-my-zsh

# Theme
ZSH_THEME="maran"

# Timestamps
HIST_STAMPS="mm/dd/yyyy"

# Plugins

plugins=(
  aws
  brew
  docker
  encode64
  git
  httpie
  last-working-dir
  supervisor
  vscode
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

RPROMPT="[%D{%m/%d/%y} - %*]"

# Vault Variables
export VAULT_ADDR=http://vault01.bmrf.io


# Terraform Aliases
alias tf='terraform'
alias tfa='terraform apply'
alias tfc='terraform console'
alias tfd='terraform destroy'
alias tfdv='terraform destroy --var-file=secrets.tfvars'
alias tff='terraform fmt'
alias tffr='terraform fmt -recursive'
alias tfg='terraform graph'
alias tfim='terraform import'
alias tfin='terraform init'
alias tfo='terraform output'
alias tfp='terraform plan'
alias tfpr='terraform providers'
alias tfr='terraform refresh'
alias tfsh='terraform show'
alias tft='terraform taint'
alias tfut='terraform untaint'
alias tfv='terraform validate'
alias tfw='terraform workspace'
alias tfs='terraform state'
alias tffu='terraform force-unlock'
alias tfwst='terraform workspace select'
alias tfwsw='terraform workspace show'
alias tfssw='terraform state show'
alias tfwde='terraform workspace delete'
alias tfwls='terraform workspace list'
alias tfsls='terraform state list'
alias tfwnw='terraform workspace new'
alias tfsmv='terraform state mv'
alias tfspl='terraform state pull'
alias tfsph='terraform state push'
alias tfsrm='terraform state rm'
alias tfaa='terraform apply -auto-approve'
alias tfda='terraform destroy -auto-approve'
alias tfinu='terraform init -upgrade'
alias tfpde='terraform plan --destroy'
alias tfpv='terraform plan --var-file=secrets.tfvars'
alias tfav='terraform apply --var-file=secrets.tfvars'
alias tfgit='touch main.tf output.tf variables.tf providers.tf settings.tf terraform.auto.tfvars; git init'