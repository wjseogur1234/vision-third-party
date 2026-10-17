# vision-third-party

비전 프로젝트에서 공용으로 참조하는 외부 라이브러리 모음.
원본 코드는 복사하지 않고 **git submodule**로 원본 저장소의 커밋만 고정한다.

| folder       | upstream                                                                 |
|--------------|--------------------------------------------------------------------------|
| `libreyolo/` | [LibreYOLO/libreyolo](https://github.com/LibreYOLO/libreyolo)            |
| `yolox/`     | [Megvii-BaseDetection/YOLOX](https://github.com/Megvii-BaseDetection/YOLOX) |
| `rf-detr/`   | [roboflow/rf-detr](https://github.com/roboflow/rf-detr)                  |
| `mmdetection/` | [open-mmlab/mmdetection](https://github.com/open-mmlab/mmdetection) |

고정 커밋·라이선스·사용처는 [THIRD_PARTY.md](THIRD_PARTY.md).

## 받기

다른 프로젝트가 `<workspace>/third_party/vision-third-party/...` 경로로 참조하므로
`third_party/` 아래에 저장소 이름 그대로 받는다.

```bash
mkdir -p third_party && cd third_party
git clone --recursive https://github.com/wjseogur1234/vision-third-party.git
# 이미 받았다면
./vision-third-party/scripts/bootstrap.sh
```

## 사용

라이브러리는 각 프로젝트 환경에 editable로 설치한다.

```bash
pip install -e third_party/vision-third-party/libreyolo
# uv: [tool.uv.sources] yolox = { path = "<상대경로>/vision-third-party/yolox", editable = true }
```

## 규칙

- submodule 안의 원본 코드는 고치지 않는다. 수정이 필요하면 원본을 fork해 submodule URL을 바꾼다.
- 라이브러리 추가: `git submodule add <url> <소문자-원본이름>` 후 THIRD_PARTY.md에 행 추가.
- 버전 변경: submodule 안에서 checkout → 상위에서 커밋 → THIRD_PARTY.md 갱신.

## 라이선스

[LICENSE](LICENSE)는 이 저장소가 직접 작성한 파일(README, 스크립트 등)에만 적용된다.
각 submodule은 원본 저장소의 라이선스를 따른다.

라이브러리·모델 가중치 추가 및 갱신 시 [license_policy.yaml](license_policy.yaml)을 적용한다.
`review_required` 라이선스는 검토 후 도입하고, `restricted` 라이선스는 도입을 제한한다.
목록에 없는 라이선스는 별도 검토한다.
상업적 사용과 비공개 제품 배포 지원 여부를 확인하고, 모델 가중치의 라이선스를 별도로 검증하며,
원본 라이선스와 제3자 고지문을 보존한다.

## 추적 브랜치

| submodule | 추적 브랜치 |
|-----------|-------------|
| `libreyolo` | `release` |
| `yolox` | `main` |

`.gitmodules`의 `branch`로 지정돼 있다. 최신으로 올리려면
`git submodule update --remote <이름>` 후 커밋한다.
