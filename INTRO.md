CAS Cloud and Platform Manager
==============================

Umgebung zum Kurs: [CAS Cloud and Platform Manager](https://www.hslu.ch/de-ch/informatik/weiterbildung/technologies-and-methods/cas-cloud/).

Services
--------

* http://${fqdn}:32188/tree/work        - Beispiele Infrastruktur (Jupyter Notebooks)
* http://${fqdn}:32188/tree/work/mlg    - Beispiele Machine Learning (Jupyter Notebooks)
* https://${fqdn}:8443                  - Kubernetes Dashboard (kein Token notwendig, Überspringen drücken)
* https://${fqdn}:4200                  - Terminal im Browser. User: ubuntu, Password insecure

SSH Access

    ssh -i ssh/lerncloud ubuntu@${fqdn}
    
Kubernetes Cluster
------------------    
    
Es werden einzelne VMs erstellt. Diese können wie folgt zu einen Kubernetes Cluster zusammengefügt werden.

Git/Bash:

    JOIN=$(ssh -i ssh/lerncloud ubuntu@${fqdn} -- microk8s add-node --token-ttl 3600 | grep worker | tail -1)
    
    # Join Worker(s)
    ssh -i ssh/lerncloud ubuntu@${worker_01_fqdn} -- $JOIN
    ssh -i ssh/lerncloud ubuntu@${worker_02_fqdn} -- $JOIN
    
PowerShell:

    icacls "ssh/lerncloud" /inheritance:r /grant:r "$($env:USERNAME):(F)"
    $JOIN=ssh -i ssh/lerncloud ubuntu@${fqdn} -- "microk8s add-node --token-ttl 3600 | grep worker | tail -1"
    Write-Output $JOIN
    
    ssh -i ssh/lerncloud ubuntu@${worker_01_fqdn} -- $JOIN
    ssh -i ssh/lerncloud ubuntu@${worker_02_fqdn} -- $JOIN

**ACHTUNG**: erst ausführen, wenn das Dashboard erreichbar ist.