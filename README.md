# 1. 개요
* 쿠버네티스 HPA와 keda 연습
* 전제조건: metrics server 원리를 알고 있어야 함
  * blog참고: https://malwareanalysis.tistory.com/659

<br>

# 2. 환경 구축
* make install로 환경구축 자동화
* 설치 목록
  * kind 클러스터 생성
  * metrics-server

```bash
make install
```

<br>

# 3. 환경 삭제
* kind 클러스터 삭제

```bash
make uninstall
```

# 4. custom 메트릭 실습
## 4.1 custom metrics 조회
* custom metrics을 조회하면, custom metrics API가 없기 때문에 에러 발생

```bash
$ kubectl get --raw "/apis/custom.metrics.k8s.io/v1beta1"
Error from server (NotFound): the server could not find the requested resource
```

* custom.metrics api가 없는 것을 확인

```bash
$ kubectl get apiservices | grep "custom"
```

## 4.2 prometheus adatper 설치
* external metrics server 역할을 하는 prometheus adatper 설치

```bash
$ make install-prometheus-adapter
$ kubectl -n default get pod
NAME                                             READY   STATUS    RESTARTS   AGE
metrics-sevrer-metrics-server-7649d7fd47-vv4g7   1/1     Running   0          49m
prometheus-adapter-6fdf67fb84-rmwt2              1/1     Running   0          46s
```

* custom metrics을 조회
* prometheus를 설치하지 않았기 때문에 resources가 null

```bash
$ kubectl get --raw "/apis/custom.metrics.k8s.io/v1beta1"
{"kind":"APIResourceList","apiVersion":"v1","groupVersion":"custom.metrics.k8s.io/v1beta1","resources":[]}
```

## 4.3 prometheus operator 설치
* custom metrics을 가져오기 위해 prometheus operator설치
```bash
$ make install-prometheus-operator
$ kubectl -n default get pod -l "release=operator"
NAME                                                   READY   STATUS    RESTARTS   AGE
operator-kube-prometheus-s-operator-54b9654c4f-4gnvq   1/1     Running   0          34s
operator-kube-state-metrics-67bcd4df86-hns7w           1/1     Running   0          34s
operator-prometheus-node-exporter-6zl7k                1/1     Running   0          34s
operator-prometheus-node-exporter-tpzxw                1/1     Running   0          34s
```

* custom.metrics api 조회

```bash
$ kubectl get apiservices | grep "custom"
v1beta1.custom.metrics.k8s.io          default/prometheus-adapter              True        55m
```

* custom metrics을 조회

```bash
$ kubectl get --raw "/apis/custom.metrics.k8s.io/v1beta1" | jq . | more
{
  "kind": "APIResourceList",
  "apiVersion": "v1",
  "groupVersion": "custom.metrics.k8s.io/v1beta1",
  "resources": [
    {
      "name": "services/go_memory_classes_heap_objects_bytes",
      "singularName": "",
      "names
  ...
}
```

# 참고자료
* [github] prometheus adapter: https://github.com/kubernetes-sigs/prometheus-adapter/blob/master/docs/walkthrough.md
* [blog] custom and external metrics: https://medium.com/uptime-99/kubernetes-hpa-autoscaling-with-custom-and-external-metrics-da7f41ff7846
* [blog] rancher prometheus adatper configruation: https://ranchermanager.docs.rancher.com/v2.0-v2.4/explanations/integrations-in-rancher/cluster-monitoring/custom-metrics#querying
