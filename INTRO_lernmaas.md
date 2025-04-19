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

    ssh -i ~/.ssh/lerncloud ubuntu@${controlplanes[idx]}
    ssh -i ~/.ssh/lerncloud ubuntu@${worker1s[idx]}
    ssh -i ~/.ssh/lerncloud ubuntu@${worker2s[idx]}

%{ endfor ~}

Services
--------

%{ for idx in range(length(controlplanes)) ~}
Gruppe ${idx + 1} Services:

* http://${controlplanes[idx]}:32188/tree/cascpm/README.ipynb - Beispiele Infrastruktur (Jupyter Notebooks)
* https://${controlplanes[idx]}:30443                         - Kubernetes Dashboard (kein Token notwendig, Überspringen drücken)
* https://${controlplanes[idx]}:4200                          - Terminal im Browser. User: ubuntu, Password insecure

%{ endfor ~}
