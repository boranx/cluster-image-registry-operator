FROM registry.svc.ci.openshift.org/openshift/release:golang-1.10 AS builder
WORKDIR /go/src/github.com/openshift/cluster-image-registry-operator
COPY . .
RUN make build

FROM registry.svc.ci.openshift.org/openshift/origin-v4.0:base
COPY --from=builder /go/src/github.com/openshift/cluster-image-registry-operator/tmp/_output/bin/cluster-image-registry-operator /usr/bin/
RUN useradd cluster-image-registry-operator
USER cluster-image-registry-operator
COPY deploy/image-references deploy/00-crd.yaml deploy/01-namespace.yaml deploy/02-rbac.yaml deploy/03-sa.yaml deploy/04-operator.yaml /manifests/
LABEL io.openshift.release.operator true
