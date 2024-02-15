<div align="center">
  <img src="https://github.com/seosieve/TopazIOS/assets/76729543/bf153ad9-ba4b-4dcd-a13a-1c64eacbb960" width="150" height="150">
  <br>
  <br>
  <img src="https://img.shields.io/badge/Swift-v5.0-red?logo=swift" />
  <img src="https://img.shields.io/badge/Xcode-v15.0-blue?logo=Xcode" />
  <img src="https://img.shields.io/badge/iOS-14.0+-black?logo=apple" />  
</div>

### 프로젝트 소개

>  Trip On Samart Phone A-Z
- 자유롭게 해외여행을 다니며 다양한 문화를 만나던 때를 기억하시나요?
- 각자가 가지고 있는 **행복했던 여행경험을 음악과 함께 공유**하고 다양한 컨텐츠를 자유롭게 이용해보세요.
<br>

### 프로젝트 주요 기능

> 스플래쉬, 온보딩 화면

<img src="https://github.com/seosieve/TopazIOS/assets/76729543/0c4bc3ff-cdd3-45a7-9cca-192508c692ce" width="20%"> <img src="https://github.com/seosieve/TopazIOS/assets/76729543/2741e194-9176-498b-b3df-aaebfa8ab5fb" width="20%">

- 처음 앱을 켰을 때, 애니메이션을 통해 눈에 띄는 첫인상을 주고싶어 **Lottie 라이브러리**를 사용했습니다.
- PageViewController와 Custom Progress Bar를 사용해 UI를 구성하였습니다.

<br>

> 회원가입 화면

<img src="https://github.com/seosieve/TopazIOS/assets/76729543/2a2db3a7-385a-4a56-91fb-3c224d0962e8" width="20%"> <img src="https://github.com/seosieve/TopazIOS/assets/76729543/9bbbee31-a82c-4ff3-afcd-f48d0f670c9b" width="20%"> <img src="https://github.com/seosieve/TopazIOS/assets/76729543/0b75f8f0-12c9-4055-86e0-71fc83bf2e09" width="20%">

- 정규표현식에 따른 올바른 이메일을 작성하고, 조건에 맞는 비밀번호를 입력하면 다음으로 넘어갑니다.
- 자주 쓰이는 정보들은 **UserDefault**에, 프로필 사진 등의 정보들은 **Firebase Storage**에 저장됩니다.

<br>

> 홈 화면

<img src="https://github.com/seosieve/TopazIOS/assets/76729543/0bd96a5a-01af-4807-b079-15e8658aa71f" width="20%"> <img src="https://github.com/seosieve/TopazIOS/assets/76729543/17986f98-59c3-4ff6-9216-df4dea40c17b" width="20%"> <img src="https://github.com/seosieve/TopazIOS/assets/76729543/7805f425-dc4b-4982-adad-e003bac1d819" width="20%">

- 앱과 함께 지구를 탐험하는 느낌을 주고싶었습니다. **실제 시간대에 따라** 지구의 테마가 다르게 나타납니다.
- **SceneKit과 cinema4D로 제작한 scn모델**을 이용해서 홈화면을 구성하였습니다.
- 대륙을 터치하면 어떤 대륙인지 볼 수 있고, 드래그를 통해 지구본을 움직여 볼 수도 있습니다.

<br>

> 여행지 추천, 검색 화면

<img src="https://github.com/seosieve/TopazIOS/assets/76729543/32af170b-bd75-4403-9088-a6a8738dc86e" width="20%"> <img src="https://github.com/seosieve/TopazIOS/assets/76729543/47a43577-9195-419f-8955-19cbbc9e3976" width="20%">

- **Unsplash API**를 사용해서 추천 여행지의 **Random Image**를 불러옵니다.
- RestCountry API를 사용해서 여행지의 사진과 맞는 국기와 인구, 경도 위도 등 기본 정보를 가져옵니다.

<br>

> 커뮤니티 화면

<img src="https://github.com/seosieve/TopazIOS/assets/76729543/4ed41aab-d0d4-4432-93a7-e48d8d7ebcf1" width="20%"> <img src="https://github.com/seosieve/TopazIOS/assets/76729543/bb7a0500-e432-448e-a0e9-15453a0a8f5b" width="20%">

- 최근 인기글들을 **공항** **컨베이어벨트의 수화물들이 움직이는 것 같은 애니메이션**으로 살펴볼 수 있습니다.
- 전체글들은 **좋아요순, 조회수순, 업로드순으로 정렬**해서 살펴볼 수 있습니다.
- **국가별로** 게시글들을 모아 그 나라에 관한 게시글들과 HOT 게시글들을 살펴볼 수도 있습니다.

<br>

> 배경음악 편집 화면

<img src="https://github.com/seosieve/TopazIOS/assets/76729543/f7ab2a41-f783-4643-be66-726fe1a31b1e" width="20%"> <img src="https://github.com/seosieve/TopazIOS/assets/76729543/97311dfb-fce7-4eaf-ba5a-ccc064526551" width="20%">

- 글의 분위기에 맞는 **배경음악을 함께 감상**할 수 있게 해서 기존 앱들과 차별성을 두고 싶었습니다.
- 메인 음악을 고르고, 어울리는 Sound Effect들을 추가해서 **나만의 배경음악을 커스텀**할 수 있습니다.

<br>

> 마이페이지 화면

<img src="https://github.com/seosieve/TopazIOS/assets/76729543/51d8e01d-a2e6-420d-83c4-69076afc641b" width="20%"> <img src="https://github.com/seosieve/TopazIOS/assets/76729543/886d76cc-a56f-4c4f-b175-6528d1c11825" width="20%"> <img src="https://github.com/seosieve/TopazIOS/assets/76729543/e84514b5-b043-4add-b37d-4b20eb3c29c0" width="20%">

- **프로필 편집, 여행 등급, 수집품** 등 다양한 정보를 살펴볼 수 있는 Travel Note 탭입니다.
- 수정, 삭제가 용이한 **내가 쓴 글들을 모아서 볼 수 있는 탭**이 있습니다.
- 설정 탭에 들어가면 차단 유저 목록, 로그아웃 등의 기능을 수행할 수 있습니다.

<br>














