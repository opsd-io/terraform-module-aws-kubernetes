#!/bin/sh -eux

aws sts get-caller-identity

aws eks update-kubeconfig \
  --region "eu-central-1" \
  --name "basic-k8s-example" \
  --alias "k8s-example"

kubectl version

kubectl auth whoami
