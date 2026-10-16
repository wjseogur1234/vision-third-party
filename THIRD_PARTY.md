# Third-party libraries

각 라이브러리는 git submodule로 원본 저장소의 특정 커밋에 고정된다.
정확한 고정 커밋은 `git submodule status`가 기준이며, 아래 표는 요약이다.

| name      | upstream                                           | commit   | version       | license    |
|-----------|----------------------------------------------------|----------|---------------|------------|
| libreyolo | https://github.com/LibreYOLO/libreyolo             | 89efbe87 | v1.6.0+2      | MIT        |
| yolox     | https://github.com/Megvii-BaseDetection/YOLOX      | 6ddff48  | 0.3.0+38      | Apache-2.0 |
| rf-detr   | https://github.com/roboflow/rf-detr                | 7433d591 | 1.11.2        | Apache-2.0 |

## Used by

| project                         | library          | how                                         |
|---------------------------------|------------------|---------------------------------------------|
| project-HNU-2026_face-detector  | yolox, rf-detr   | `research/envs/{yolox,rfdetr}` editable 설치 |
