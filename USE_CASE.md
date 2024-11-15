# Case Study for DevSecOps role at Yarowa AG

This repository is the base of the case study for all potential DevSecOps engineers at Yarowa AG.

## Instructions

1. Fork this repository and mark it as private.
1. Build an application using the programming language of your choice in the `app/` folder which runs a webservice on Port 5000 and responds with "Hello Yarowa AG!" to any requests (e.g. curl http://localhost:5000/).
1. Build a Dockerfile which packages the app into a container and runs the previously written app on startup.
1. Build a Helmchart in `helmchart/` that runs the docker container in a deployment with a service and ingress infront of it.
1. Orchestrate the helmchart deployment in `helmfile.d/` and add all helm charts needed to serve the application starting from a brand new kind/k3s/minikube cluster.
1. Commit all code to your repo.
1. Send the zipped repo to your contact at Yarowa and wait for feedback.

## Guidelines / Rules

- Please take note on how long you took to get this case study done (ideally you shouldn't spend more than 4 hours).
- The ingress should listen to the Domain/Host: casestudy.local.yarowa.io (DNS is statically pointing to 127.0.0.1 so you will need to setup a minikube/k3s/kind environment that listens on localhost).
- The ingress should listen on HTTP only and forward the requests to the setup service.
- You might need to publish your Dockerimage on dockerhub.com or leave instructions on how the k8s cluster can pull the image.
- Your custom helmchart for the "Hello Yarowa!" applicatioan can be referenced using relative paths (e.g. `chart: ../helmchart/mychart`).
- Please transparently declare the use of ChatGPT or other AI helpers as comments in the files if you use them.
- If you add other helmcharts with ingresses you can use *.local.yarowa.io (e.g. grafana.local.yarowa.io)

## Scoring

The verifier of this challenge will clone your repository and run "helmfile apply ." and then trying to access casestudy.local.yarowa.io in a browser. Make sure to leave instructions if the kind/minikube/k3s setup needs special configs to expose the ports 80 / 443.

- `app/` contains working code: 10 Points
- `helmchart/` contains working helmchart: 10 Points
- `helmfile.d/` contains full orchestration of setup: 30 Points
- verifier can successfully open casestudy.local.yarowa.io and received "Hello Yarowa!" as response: 50 Points
- Up to 50 Bonus points for: elegant code (10pts), full instrumentation (20pts), test cases (10pts), surprising solutions (10pts)
- Maximum Score: 150 Points