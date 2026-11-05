# 라벨링 및 학습 데이터셋 구성 가이드

## 목적과 적용 범위

라벨링 원본을 모델과 독립적으로 보존하고, 객체 검출용 공통 학습 데이터는 COCO JSON으로
내보낸다. 각 프로젝트의 학습 설정에서 경로와 클래스 매핑을 연결한다.
YOLO TXT는 필요할 때 파생 export로 생성한다.

이 문서는 현재 submodule 소스의 정적 분석 결과다. 실제 학습 실행이나 모든 모델·작업의
포맷 호환성을 검증한 결과는 아니다. submodule 갱신 시 데이터 로더를 다시 확인한다.

| 프로젝트 | 확인 커밋 | 학습 실행 구조 | 데이터 입력 |
|---|---|---|---|
| LibreYOLO | `89efbe87` | 공통 BaseTrainer와 모델별 Trainer | 데이터 YAML, YOLO TXT 또는 COCO JSON |
| YOLOX | `6ddff48` | Python Exp와 자체 Trainer | 기본 경로는 COCO JSON |
| RF-DETR | `7433d591` | LightningModule, DataModule, Trainer | COCO, Roboflow COCO, YOLO 등 |
| MMDetection | `cfd5d3a9` | Python Config와 MMEngine Runner | Dataset·변환·평가기 설정, COCO 지원 |

LibreYOLO 내부 RF-DETR과 독립 RF-DETR 프로젝트는 학습 진입점과 데이터 설정이 다르다.

## 라벨링 원본과 학습 export

라벨링 시스템에는 원본 이미지, 고유 이미지·객체 ID, 클래스 정의, 어노테이션,
검수 상태, 촬영 영상·세션 등 분할용 그룹 정보를 보존한다.
학습 export에는 검수 완료 데이터만 포함한다. 이미지의 파일명·경로가 바뀌더라도
원본 ID를 통해 출처를 추적할 수 있도록 한다.

데이터셋 버전마다 클래스 목록, split 구성, 원본과 export의 대응 관계를 고정한다.
같은 버전의 파일을 덮어쓰지 말고 새 버전을 만든다. 사용 이미지·데이터의 라이선스는
[라이선스 정책](../LICENSE_POLICY.md)에 따라 별도로 확인한다.

## 공통 객체 검출 export

```text
dataset-v001/
├── train2017/
│   ├── image_0001.jpg
│   └── image_0002.jpg
├── val2017/
│   └── image_0101.jpg
├── annotations/
│   ├── instances_train2017.json
│   └── instances_val2017.json
└── dataset.yaml                 # LibreYOLO용
```

`2017`은 기본 로더의 경로 관례에 맞춘 이름이며 촬영 연도일 필요는 없다.
train은 학습, val은 학습 중 검증에 사용한다. 최종 평가용 test는 별도로 보존하고
프로젝트별 로더에 맞춰 export한다. test 경로·파일명까지 네 프로젝트가 같다고 가정하지 않는다.

각 split의 JSON은 해당 split의 이미지·어노테이션과 공통 클래스 목록을 담는다.
다음은 이미지 하나와 객체 하나를 담은 예시다.

```json
{
  "images": [
    {"id": 1, "file_name": "image_0001.jpg", "width": 1920, "height": 1080}
  ],
  "categories": [
    {"id": 1, "name": "person"}
  ],
  "annotations": [
    {
      "id": 1,
      "image_id": 1,
      "category_id": 1,
      "bbox": [100, 200, 80, 160],
      "area": 12800,
      "iscrowd": 0
    }
  ]
}
```

| 필드 | 규칙 |
|---|---|
| `images.id` | JSON 내 고유 ID. 출처 추적을 위해 데이터셋 전체에서도 고유하게 관리 권장 |
| `file_name` | 해당 split 이미지 디렉터리 기준 상대 경로 |
| `width`, `height` | 실제 저장된 이미지의 픽셀 크기 |
| `annotations.id` | JSON 내 고유 ID |
| `image_id`, `category_id` | 실제 존재하는 이미지·클래스 ID 참조 |
| `bbox` | 픽셀 단위 `[왼쪽 x, 위쪽 y, 너비, 높이]`, 정규화 좌표가 아님 |
| `area` | 박스 전용 검출 예시는 너비×높이. 분할 라벨은 실제 마스크 면적 사용 |
| `iscrowd` | 일반 개별 객체는 0. 미검수·불확실 객체 표시 용도로 사용하지 않음 |

너비·높이가 0 이하인 박스, 이미지 경계를 벗어난 좌표, 회전·리사이즈 전후가 섞인
좌표를 export하지 않는다. 저장 이미지의 방향과 라벨 좌표를 일치시킨다.

## 클래스 ID와 데이터 분할

클래스 이름과 ID는 모든 split에서 동일하게 유지한다. 특정 split에 없는 클래스도
공통 `categories` 목록에 유지한다. 클래스명은 중복되지 않게 정의한다.

COCO `category_id`와 모델 내부 클래스 번호는 별개다. 예를 들어 COCO `1: person`을
YOLO TXT에서는 `0: person`으로 내보낼 수 있다. 매핑을 명시적으로 기록하고,
split마다 독립적으로 번호를 다시 부여하지 않는다.

같은 영상의 연속 프레임, 같은 촬영 세션·대상, 중복 이미지는 그룹 단위로 분할한다.
분할 비율보다 train과 val/test 사이의 데이터 누수 방지가 우선이다.
분할 결과를 버전별로 고정하고 모델을 바꿔도 같은 평가 데이터를 사용한다.

객체가 없다고 **검수 완료된 이미지**는 `images`에 포함하고 해당 어노테이션을 두지 않는다.
미라벨링·미검수 이미지는 이 경우와 구분해 학습 export에서 제외한다.
빈 이미지가 실제 학습에 포함되는지는 로더 설정도 확인한다. 예를 들어 MMDetection의
기본 COCO 설정에는 `filter_empty_gt=True`가 있어 학습 중 제외될 수 있다.

## 프로젝트별 연결

### LibreYOLO

공통 디렉터리를 다음 데이터 YAML로 연결한다. 실제 데이터셋의 절대 경로로 교체한다.
COCO 카테고리 이름과 YAML `names`를 동일하게 유지한다.

```yaml
path: /absolute/path/dataset-v001
train: train2017
val: val2017
annotations:
  train: annotations/instances_train2017.json
  val: annotations/instances_val2017.json
names:
  0: person
```

COCO 로더는 YAML의 클래스 이름으로 COCO category와 내부 label을 연결한다.
작업별 Trainer가 이 입력 경로를 사용하는지는 선택한 모델·작업에서 확인한다.

### YOLOX

커스텀 Python `Exp`에서 다음 값을 지정한다.

```python
self.data_dir = "/absolute/path/dataset-v001"
self.train_ann = "instances_train2017.json"
self.val_ann = "instances_val2017.json"
self.num_classes = 1
```

기본 로더는 JSON을 `data_dir/annotations/`에서, 이미지를 `train2017/`, `val2017/`에서
읽는다. category ID를 정렬해 연속 label로 매핑하므로 클래스 순서를 확인한다.
다른 이미지 폴더를 쓰려면 Exp의 dataset 생성 부분도 변경해야 한다.

### RF-DETR

공통 디렉터리는 `dataset_file="coco"`로 선택할 수 있다. 다만 현재 검출용 COCO 경로는
category ID를 자동으로 연속 label로 재매핑하지 않으므로, 커스텀 클래스의 ID와 모델
출력 클래스 공간을 별도로 정합해야 한다. 경로만 맞춘 상태를 학습 준비 완료로 보지 않는다.

커스텀 데이터에는 동일한 COCO 내용으로 **Roboflow COCO export**를 만드는 방법이 있다.
이 경로는 train 기준 클래스 매핑을 다른 split에 재사용한다. Roboflow 서비스 이용은 필수가 아니다.

```text
dataset-v001-rfdetr/
├── train/
│   ├── image_0001.jpg
│   └── _annotations.coco.json
├── valid/
│   ├── image_0101.jpg
│   └── _annotations.coco.json
└── test/                       # 테스트 실행 시 준비
    ├── image_0201.jpg
    └── _annotations.coco.json
```

학습 호출에 `dataset_dir`와 `dataset_file="roboflow"`를 지정한다.
이미지 복제·링크나 export 경로 변경 시 JSON `file_name`도 해당 폴더 기준으로 맞춘다.
원본 split과 클래스 목록은 유지하고 RF-DETR용으로 다시 분할하지 않는다.

### MMDetection

선택한 모델의 Python config에서 각 split의 다음 항목을 지정한다.

- `dataset.type="CocoDataset"`
- `dataset.data_root`: 데이터셋 루트
- `dataset.ann_file`: `annotations/instances_train2017.json` 또는 val JSON
- `dataset.data_prefix.img`: `train2017/` 또는 `val2017/`
- `dataset.metainfo.classes`: 공통 클래스 목록에 맞춘 tuple
- `val_evaluator.ann_file`: 검증 JSON 경로

모델 head의 클래스 수도 실제 클래스 수에 맞춘다. head 설정 경로는 모델별로 다르다.
중첩 dataset wrapper가 있는 설정은 내부 dataset까지 경로·클래스 설정을 확인한다.

## YOLO TXT 파생 export

```text
dataset-yolo/
├── images/train/image_0001.jpg
├── images/val/image_0101.jpg
├── labels/train/image_0001.txt
├── labels/val/image_0101.txt
└── data.yaml
```

객체 검출 TXT는 객체마다 `class_id center_x center_y width height` 한 줄을 쓴다.
클래스는 0부터 시작하고 좌표는 이미지 크기로 나눈 0~1 값이다.
COCO `[x, y, w, h]`의 중심은 `(x+w/2, y+h/2)`로 계산한다.
검수된 빈 이미지는 빈 TXT로 명시할 수 있다. 누락 TXT를 미검수 상태 표시에 사용하지 않는다.

## 객체 검출 외 작업

| 작업 | 라벨링 원본에 추가로 보존할 정보 |
|---|---|
| 인스턴스 분할 | 객체별 polygon 또는 mask/RLE, 구멍·겹침 처리 규칙 |
| 키포인트 | 점 이름·순서·좌표·가시성, skeleton 및 좌우 반전 대응 |
| 회전 객체 검출 | 네 꼭짓점 또는 회전 사각형, 각도·점 순서 규칙 |
| 객체 추적 | 영상 ID, 프레임 순서·시간, 객체 track ID |
| 의미 분할 | 픽셀별 클래스 mask, 배경·무시 값, 클래스 매핑 |

박스만으로 mask나 키포인트를 복원할 수 없다. 분할이 필요하면 처음부터 윤곽을 보존하고
박스를 파생한다. 위 작업 전체를 네 프로젝트가 동일한 포맷으로 지원하는 것은 아니므로,
선택한 모델의 dataset·loss·평가 입력을 별도로 확인한다.

## 학습 전 확인

1. JSON 파싱, 참조 ID, 실제 파일·이미지 크기, 박스·mask 유효성을 검사한다.
2. 모든 split에서 클래스 정의와 내부 label 매핑을 확인한다.
3. 원본 이미지 위에 라벨을 그려 위치·클래스·방향을 눈으로 검수한다.
4. 중복·영상 그룹이 split 경계를 넘지 않는지 확인한다.
5. 각 프로젝트의 DataLoader에서 소량을 읽고 변환 이후 라벨도 확인한다.
6. 소량 학습·검증으로 loss, 클래스별 지표와 저장 결과를 확인한 뒤 전체 학습한다.

## 소스 근거

- LibreYOLO: [공통 Trainer](../libreyolo/libreyolo/training/trainer.py), [데이터 YAML 로더](../libreyolo/libreyolo/data/utils.py), [COCO 클래스 매핑](../libreyolo/libreyolo/data/dataset.py)
- YOLOX: [학습 진입점](../yolox/tools/train.py), [Exp](../yolox/yolox/exp/yolox_base.py), [COCO 로더](../yolox/yolox/data/datasets/coco.py)
- RF-DETR: [학습 API](../rf-detr/src/rfdetr/detr.py), [Trainer](../rf-detr/src/rfdetr/training/trainer.py), [포맷 선택](../rf-detr/src/rfdetr/datasets/__init__.py), [COCO 경로·매핑](../rf-detr/src/rfdetr/datasets/coco.py)
- MMDetection: [학습 진입점](../mmdetection/tools/train.py), [COCO 기본 설정](../mmdetection/configs/_base_/datasets/coco_detection.py)
