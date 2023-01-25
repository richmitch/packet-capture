{{- define "library.packetcapture.policy" -}}
{{- if .Values.packetcapture }}
{{- $pcap := .Values.packetcapture }}
{{- if .Values.namespaces }}
{{- range $ns := .Values.namespaces }}
{{- if $ns.deployments }}
{{- range $deploy := $ns.deployments }}
---
apiVersion: policy.open-cluster-management.io/v1
kind: Policy
metadata:
{{- include "packetcapture.labels" $ | indent 2 }}
  name: "pcap-{{ $ns.name }}-{{ $deploy.name }}"
  namespace: {{ $pcap.namespace }}  
  annotations:
spec:
  remediationAction: {{ $deploy.remediationAction }}
  disabled: {{ $deploy.disabled }}
  policy-templates:
  - objectDefinition:
      apiVersion: policy.open-cluster-management.io/v1
      kind: ConfigurationPolicy
      metadata:
        name: "pcap-{{ $deploy.name }}"
      spec:
        remediationAction: inform
        severity: high
        namespaceSelector:
          exclude:
          - kube-*
          - openshift-*
          - open-*
        object-templates:
        - complianceType: musthave
          objectDefinition:
            apiVersion: apps/v1
            kind: DaemonSet
            metadata:
              name: "packet-capture-{{ $deploy.name }}"
              namespace: {{ $ns.name }}
            spec:
              selector:
                matchLabels:
                  operations.network/packet-capture: enabled
              template:
                metadata:
                  annotations:
                    cluster-autoscaler.kubernetes.io/enable-ds-eviction: "true"
                    target.workload.openshift.io/management: '{"effect": "PreferredDuringScheduling"}'
                  labels:
                    operations.network/packet-capture: enabled
                spec:
                  containers:
                    - name: webserver
                      image: httpd
                      ports:
                        - containerPort: 80
                      volumeMounts:
                      - mountPath: /etc/packet-capture/packet-capture.conf
                        subPath: packet-capture.conf
                        readOnly: true
                        name: packet-capture-vol
                  volumes:
                  - name: packet-capture-vol
                    configMap:
                      name: packet-capture
              updateStrategy:
                rollingUpdate:
                  maxSurge: 0
                  maxUnavailable: 10%
                type: RollingUpdate
        - complianceType: musthave
          objectDefinition:
            apiVersion: v1
            kind: ConfigMap
            metadata:
              name: "packet-capture-{{ $deploy.name }}"
              namespace: {{ $ns.name }}
            data:
              namespace: {{ $ns.name }}
              deployment: {{ $deploy.name }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}