# 개요
* 쿠버네티스 HPA와 keda 연습

<br>

# 환경구축
* make install로 환경구축 자동화
* 설치 목록
  * kind 클러스터 생성
  * metrics-server
  * prometheus-adapter

```bash
make install
```

<br>

# 환경 삭제
* kind 클러스터 삭제

```bash
make uninstall
```

# 참고자료
* prometheus adapter github: https://github.com/kubernetes-sigs/prometheus-adapter/blob/master/docs/walkthrough.md
