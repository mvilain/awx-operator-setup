# awx-operator in a kubernetes cluster

Based on [AWX Operator modue](https://github.com/ansible/awx-operator)

## Articles on on containers and a cheat-sheet

- https://www.capitalone.com/tech/cloud/what-is-a-container/
- https://www.capitalone.com/tech/cloud/container-runtime/
- https://wizardzines.com/zines/containers/

## Demo of actual implementation of awx-operator

The demo file awx-operator.cast can be viewed using the python3 module 
[asciinema](https://github.com/asciinema/asciinema.git). To install it,
do the following:

    git clone https://github.com/asciinema/asciinema.git
    cd asciinema
    python3 -m asciinema --version
    python3 -m asciinema asciinema play ../awx-operator.cast
