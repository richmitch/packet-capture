{{- define "library.packetcapture.policy" -}}
{{- if .Values.packetcapture }}
{{- $pcap := .Values.packetcapture }}
{{- if .Values.deployments }}
{{- range $deploy := .Values.deployments }}
---
apiVersion: policy.open-cluster-management.io/v1
kind: Policy
metadata:
{{- include "packetcapture.labels" $ | indent 2 }}
  name: {{ "pcap-" $deploy.namespace }}
  namespace: {{ $pcap.namespace }}  
  annotations:
spec:
  remediationAction: {{ $deploy.remediationAction | default "inform"  }}
  disabled: {{ $deploy.disabled | default "true" }}
  policy-templates:
  - objectDefinition:
      apiVersion: policy.open-cluster-management.io/v1
      kind: ConfigurationPolicy
      metadata:
        name: {{ "pcap-ds-" $deploy.namespace }}
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
              name: packet-capture
              namespace: {{ $deploy.namespace }}
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
              name: packet-capture
              namespace: operations
            data:
              namespace: {{ $deploy.namespace }}
              deployment: {{ $deploy.name }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}