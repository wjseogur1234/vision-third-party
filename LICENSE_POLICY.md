# 라이선스 도입 정책

분류 기준은 [license_policy.yaml](license_policy.yaml)이다. `preferred`도 개별 파일,
의존성, 가중치, 데이터의 사용 승인을 의미하지 않는다. 목록에 없는 라이선스,
기업 전용 약관, 폰트·문서 라이선스는 기본적으로 별도 검토한다.

코드, 모델 가중치, 데이터셋의 라이선스를 각각 확인한다. 모델명이나 저장소 코드의
라이선스만으로 가중치의 상업적 사용·재배포 가능 여부를 판단하지 않는다.
LLaMA, Gemma, OpenRAIL, DeepFloyd 계열은 실제 모델 버전의 약관과 사용 제한을 확인한다.
데이터 라이선스는 해당 데이터에 적용하며 코드나 다른 자산으로 자동 확대하지 않는다.

도입 시 출처 URL, 버전·커밋 또는 파일 해시, 실제 라이선스 원문과 적용 범위,
상업적 사용·비공개 제품 배포 검토 결과, 수정·재배포·서비스 제공 조건,
저작자 표시·LICENSE·NOTICE 보존 방법과 검토 결과를 THIRD_PARTY.md에 기록한다.
조건을 충족하지 못하거나 근거가 없는 항목은 승인 완료로 표시하지 않는다.
NC 조건은 상업적 사용 요건과 충돌하므로 제한하고, SA·ND 조건은 예정된 사용과
배포 방식에 맞는지 검토한다. 퍼블릭 도메인 계열도 데이터의 개인정보·상표 등
별도 권리까지 해결되었다는 뜻은 아니다.

## 참고 문서와 보정

[Wikidocs 참고 문서](https://wikidocs.net/277994#1-ai)의 자산 종류 구분을 반영하되,
분류와 약어는 실제 라이선스 원문을 우선한다.

- `BSL-1.0`은 [Boost Software License](https://spdx.org/licenses/BSL-1.0.html)이다.
- EUPL-1.1은 [카피레프트 조건](https://interoperable-europe.ec.europa.eu/licence/european-union-public-licence-version-11-eupl)이 있어 검토 대상으로 둔다.
- MPL·LGPL·EPL을 일괄적으로 강한 카피레프트로 취급하지 않는다. 적용 범위와 결합·배포 조건을 검토한다. [MPL FAQ](https://www.mozilla.org/en-US/MPL/2.0/FAQ/), [EPL 설명](https://www.eclipse.org/lists/osbea-wg/pdfwNTsaYYljQ.pdf).
- `LGPL-LR`이라는 표기만으로 `LGPLLR`과 동일하다고 판정하지 않는다. [SPDX 목록](https://spdx.org/licenses/)의 정식 명칭은 Lesser General Public License For Linguistic Resources이다.
- `PDDL`, `ODBL`, `ODC-BY`는 각각 `PDDL-1.0`, `ODbL-1.0`, `ODC-By-1.0`처럼 정확한 버전을 기록한다.
- AI 모델 계열 전체를 일괄 승인하지 않는다. 예를 들어 [Gemma 약관](https://ai.google.dev/gemma/terms)은 적용 대상 모델을 구분한다.
- NC는 단순히 비영리 조직 여부를 뜻하지 않는다. [CC BY-NC 조건](https://creativecommons.org/licenses/by-nc/4.0/)에 따라 상업적 목적의 사용 여부를 확인한다.
