CAS Cloud and Platform Manager
==============================

Umgebung zum Kurs: [CAS Cloud and Platform Manager](https://www.hslu.ch/de-ch/informatik/weiterbildung/technologies-and-methods/cas-cloud/).

Join Worker Nodes
-----------------

Einträge für `00-microk8s-join.ipynb`

%{ for idx in range(length(controlplanes)) ~}
Gruppe ${idx + 1}:

import os
os.environ['ControlPlane']='${controlplanes[idx]}'
os.environ['Worker1']='${worker1s[idx]}'
os.environ['Worker2']='${worker2s[idx]}'

%{ endfor ~}

SSH Access
----------

%{ for idx in range(length(controlplanes)) ~}
Gruppe ${idx + 1}:

    Development:
    ssh -i ~/.ssh/lerncloud ubuntu@${devs[idx]}

    Build (CI/CD): 
    ssh -i ~/.ssh/lerncloud ubuntu@${builds[idx]}

    Production (Control-Plane und Worker-Nodes):
    ssh -i ~/.ssh/lerncloud ubuntu@${controlplanes[idx]}
    ssh -i ~/.ssh/lerncloud ubuntu@${worker1s[idx]}
    ssh -i ~/.ssh/lerncloud ubuntu@${worker2s[idx]}

%{ endfor ~}

Services
--------

%{ for idx in range(length(controlplanes)) ~}
Gruppe ${idx + 1} Services:

    Development:
    - http://${devs[idx]}:32188/tree/cascpm/01-dev/README.ipynb - Beispiele Infrastruktur (Jupyter Notebooks)
    - https://${devs[idx]}:30443                                - Kubernetes Dashboard (kein Token notwendig, Überspringen drücken)
    - https://${devs[idx]}:4200                                 - Terminal im Browser. User: ubuntu, Password insecure
    - http://${devs[idx]}:7500                                  - FRP (Fast Reverse Proxy). User: admin, Password insecure

    Build (CI/CD):
    - http://${builds[idx]}:32188/tree/cascpm/02-build/README.ipynb  - Beispiele Infrastruktur (Jupyter Notebooks)
    - http://${builds[idx]}                                          - Gitlab CE
    - https://${builds[idx]}:30443                                   - Kubernetes Dashboard (kein Token notwendig, Überspringen drücken)
    - https://${builds[idx]}:4200                                    - Terminal im Browser. User: ubuntu, Password insecure


    Production (Control-Plane und Worker-Nodes):
    - http://${controlplanes[idx]}:32188/tree/cascpm/03-prod/README.ipynb - Beispiele Infrastruktur (Jupyter Notebooks)
    - https://${controlplanes[idx]}:30443                                 - Kubernetes Dashboard (kein Token notwendig, Überspringen drücken)
    - https://${controlplanes[idx]}:4200                                  - Terminal im Browser. User: ubuntu, Password insecure

%{ endfor ~}
