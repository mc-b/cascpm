CAS Cloud and Platform Manager
==============================

Umgebung zum Kurs: [CAS Cloud and Platform Manager](https://www.hslu.ch/de-ch/informatik/weiterbildung/technologies-and-methods/cas-cloud/).

Services
--------

* http://${fqdn}:32188/tree/cascpm/README.ipynb - Beispiele Infrastruktur (Jupyter Notebooks)
* https://${fqdn}:30443                         - Kubernetes Dashboard (kein Token notwendig, Überspringen drücken)
* https://${fqdn}:4200                          - Terminal im Browser. User: ubuntu, Password insecure

SSH Access
----------

    ssh -i ~/.ssh/lerncloud ubuntu@${fqdn}
    
Join Worker Nodes
-----------------

Einträge für `00-microk8s-join.ipynb`

    import os
    os.environ['ControlPlane']='${fqdn}'
    os.environ['Worker1']='${worker_01_fqdn}'
    os.environ['Worker2']='${worker_02_fqdn}'
