1. Установить docker: apt-get  install docker.io
3. Создать файл Dockerfile
2. docker build -t web:1.0.0 .
4. Проверка пользователя

```
docker exec -it myweb sh
/app $ whoami
appuser
/app $ id
uid=10001(appuser) gid=10001(appuser) groups=10001(appuser)

docker top myweb
UID                 PID                 PPID                C                   STIME               TTY                 TIME                CMD
10001               69898               69876               0                   14:51               ?                   00:00:00            python -m http.server --bind 0.0.0.0 8000

docker images web:1.0.0
REPOSITORY   TAG       IMAGE ID       CREATED          SIZE
web          1.0.0     c99fd2a018d4   19 minutes ago   47.4MB
```

5. Переименовать image - docker tag web:1.0.0 leonsam2/my-repo-lab3-ls:1.0.0
6. Создать рпеозиторий в DockerHub, авторизация в консоли docker login
7. docker push leonsam2/my-repo-lab3-ls:1.0.0
8. Установка Kubernetes. 

    ```sh 
    snap install k8s --classic 
    ``` 
    k8s (1.32-classic/stable) v1.32.11 from Canonical✓ installed

    ```sh 
    snap install kubectl --classic 
    ``` 
    kubectl 1.34.3 from Canonical✓ installed

    ```sh
        curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
        chmod +x ./kind
        sudo mv ./kind /usr/local/bin/
        % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                        Dload  Upload   Total   Spent    Left  Speed
        100    97  100    97    0     0    680      0 --:--:-- --:--:-- --:--:--   683
        0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
        100 6304k  100 6304k    0     0  13.6M      0 --:--:-- --:--:-- --:--:-- 13.6M
        root@vdska:~/test_lab3/smths# kind create cluster
        Creating cluster "kind" ...
        ✓ Ensuring node image (kindest/node:v1.27.3) 🖼 
        ✓ Preparing nodes 📦  
        ✓ Writing configuration 📜 
        ✓ Starting control-plane 🕹️ 
        ✓ Installing CNI 🔌 
        ✓ Installing StorageClass 💾 
        Set kubectl context to "kind-kind"
        You can now use your cluster with:

        kubectl cluster-info --context kind-kind

        Not sure what to do next? 😅  Check out https://kind.sigs.k8s.io/docs/user/quick-start/
    ```

9. Проверка 
kubectl get nodes
NAME                 STATUS   ROLES           AGE    VERSION
kind-control-plane   Ready    control-plane   111s   v1.27.

kubectl get pods
No resources found in default namespace.

10. Установка манифеста
kubectl apply -f web-manifest.yaml
deployment.apps/web created
service/web-service created

kubectl get all
NAME                       READY   STATUS    RESTARTS   AGE
pod/web-75459fc5dd-kfzkx   1/1     Running   0          10s
pod/web-75459fc5dd-kpmrr   1/1     Running   0          10s
NAME                  TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
service/kubernetes    ClusterIP   10.96.0.1      <none>        443/TCP        11m
service/web-service   NodePort    10.96.214.85   <none>        80:30080/TCP   10s

11. Проброс порта
kubectl port-forward service/web-service 9991:80
Forwarding from 127.0.0.1:9991 -> 8000
curl http://localhost:9991
```html
<!DOCTYPE HTML>
<html lang="en">
<head>
<meta charset="utf-8">
<style type="text/css">
:root {
color-scheme: light dark;
}
</style>
<title>Directory listing for /</title>
</head>
<body>
<h1>Directory listing for /</h1>
<hr>
<ul>
<li><a href="hello.html">hello.html</a></li>
</ul>
<hr>
</body>
</html>
```
Handling connection for 9991

12. kubectl describe deployment web
```
Name:                   web
Namespace:              default
CreationTimestamp:      Sun, 28 Dec 2025 15:46:09 +0000
Labels:                 <none>
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               app=web-app
Replicas:               2 desired | 2 updated | 2 total | 2 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=web-app
  Containers:
   web-server:
    Image:         leonsam2/my-repo-lab3-ls:1.0.0
    Port:          8000/TCP
    Host Port:     0/TCP
    Liveness:      http-get http://:8000/ delay=5s timeout=1s period=10s #success=1 #failure=3
    Environment:   <none>
    Mounts:        <none>
  Volumes:         <none>
  Node-Selectors:  <none>
  Tolerations:     <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
OldReplicaSets:  <none>
NewReplicaSet:   web-75459fc5dd (2/2 replicas created)
Events:
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  27m   deployment-controller  Scaled up replica set web-75459fc5dd to 2
```

