PROJECT_NAME := "svc"
PROJECT_HOME := "$HOME/.svc"

.PHONY: all dep install update

all: help

install: dep ## Install svc
	@if ! hash svc 2>/dev/null ; then\
	    sudo cp svc /usr/local/bin/;\
	    sudo cp svc_prompt /etc/bash_completion.d/;\
	    sudo chmod +x /usr/local/bin/svc;\
	    sudo chmod +x /etc/bash_completion.d/svc_prompt;\
	    cp -r .svc ${HOME};\
	fi
	
dep: ## Get the dependencies
	@if ! hash screen 2>/dev/null ; then\
	    sudo apt-get install screen;\
	fi

run: dep install ## Run svc
	@svc

update: dep ## Overwrite svc install
	@sudo cp svc /usr/local/bin/
	@sudo cp svc_prompt /etc/bash_completion.d/
	@sudo chmod +x /usr/local/bin/svc
	@sudo chmod +x /etc/bash_completion.d/svc_prompt
	@cp -r .svc ${HOME}

help: ## Display this help screen
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

