The YAML in this directory are logically grouped as follows: 


Main: These form the core of the application. They are 3 microservices. `s1` and `s2` are organized differently in that `s1.yaml` holds `Service`, `ServiceAccount` and `Deployment` while `s2` breaks out its `Deployment` into a separate `s2-dpl-v1.yaml` to allow for version swapping.
```
│   ├── ./cluster/db-tpl.yaml
│   ├── ./cluster/s1-tpl.yaml
│   ├── ./cluster/s2-svc.yaml
│   ├── ./cluster/s2-dpl-v1-tpl.yaml
```

istio: These are the required components to use istio: one gateway and a `VirtualService` for each `Service`.
```
│   ├── ./cluster/db-vs.yaml
│   ├── ./cluster/s1-vs.yaml
│   ├── ./cluster/s2-vs.yaml
│   ├── ./cluster/service-gateway.yaml
```

Misc:
```
│   ├── ./cluster/loader-tpl.yaml
│   ├── ./cluster/awscred-tpl.yaml
│   ├── ./cluster/cloudformationdynamodb-tpl.json
│   ├── ./cluster/tpl-vars-blank.txt
```

Monitoring:
```
│   ├── ./cluster/db-sm.yaml
│   ├── ./cluster/s1-sm.yaml
│   ├── ./cluster/s2-sm.yaml
│   ├── ./cluster/dynamodb-service-entry-tpl.yaml
│   ├── ./cluster/eks-admin-service-account.yaml
│   ├── ./cluster/grafana-flask-configmap.yaml
│   ├── ./cluster/monitoring-virtualservice.yaml
```

Experiments:
```
│   ├── ./cluster/db-nohealth-tpl.yaml
│   ├── ./cluster/db-vs-delay.yaml
│   ├── ./cluster/db-vs-fault.yaml
│   ├── ./cluster/s1-nohealth-tpl.yaml
│   ├── ./cluster/s2-dpl-v2-tpl.yaml
│   ├── ./cluster/s2-nohealth-tpl.yaml
│   ├── ./cluster/s2-vs-canary.yaml
```
