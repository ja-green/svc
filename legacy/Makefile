SHELL 	:= /bin/bash
PROJECT  = svc
DATE     = $(shell date +%D)
P_HOME  := "$HOME/.svc"

VERBOSE  = 0
FILTER   = $(if $(filter 1,${VERBOSE},,@)
GCC      = gcc

.PHONY: all dep install update

all: help

install: dep ## Install svc
	@if ! hash svc 2>/dev/null ; then\
	    sudo cp legacy/svc /usr/local/bin/;\
	    sudo cp legacy/svc_prompt /etc/bash_completion.d/;\
	    sudo chmod +x /usr/local/bin/svc;\
	    sudo chmod +x /etc/bash_completion.d/svc_prompt;\
	    cp -r .svc ${HOME};\
	    cp UPDATE ${HOME}/.svc;\
	    date +%D > ${HOME}/.svc/UPDATE;\
	fi

dep: ## Get the dependencies
	@if ! hash screen 2>/dev/null ; then\
	    sudo apt-get install screen;\
	fi

run: dep install ## Run svc
	@./legacy/svc

update: dep ## Overwrite svc install
	@sudo cp /legacy/svc /usr/local/bin/
	@sudo cp /legacy/svc_prompt /etc/bash_completion.d/
	@sudo chmod +x /usr/local/bin/svc
	@sudo chmod +x /etc/bash_completion.d/svc_prompt
	@cp -r .svc ${HOME}
	@cp UPDATE ${HOME}/.svc
	@date +%D > ${HOME}/.svc/UPDATE

help: ## Display this help screen
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

