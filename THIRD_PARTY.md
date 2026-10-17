# Third-party libraries

각 라이브러리는 git submodule로 원본 저장소의 특정 커밋에 고정된다.
정확한 고정 커밋은 `git submodule status`가 기준이며, 아래 표는 요약이다.

도입 정책은 [license_policy.yaml](license_policy.yaml)을 따른다.
아래 라이선스 열은 저장소 코드 기준이며, 모델 가중치의 라이선스 검증 완료를 의미하지 않는다.
모델 가중치 도입 시 출처·버전·라이선스·검증 결과를 별도로 기록한다.

| name      | upstream                                           | commit   | version       | license    |
|-----------|----------------------------------------------------|----------|---------------|------------|
| libreyolo | https://github.com/LibreYOLO/libreyolo             | 89efbe87 | v1.6.0+2 (release) | MIT        |
| yolox     | https://github.com/Megvii-BaseDetection/YOLOX      | 6ddff48  | 0.3.0+38 (main) | Apache-2.0 |
| rf-detr   | https://github.com/roboflow/rf-detr                | 7433d591 | 1.11.2        | Apache-2.0 |
| mmdetection | https://github.com/open-mmlab/mmdetection        | cfd5d3a9 | v3.3.0+5      | Apache-2.0 |
