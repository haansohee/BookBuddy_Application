<div align="center">

<img src="BookBuddy/Assets.xcassets/AppIcon.appiconset/1024.png" alt="BookBuddy Logo" width="120" />

# BookBuddy (북버디)

**책으로 연결되는 독서 커뮤니티, 나만의 독서 친구**

![Swift](https://img.shields.io/badge/Swift-5.0-orange?logo=swift)
![iOS](https://img.shields.io/badge/iOS-17.0+-black?logo=apple)
![Xcode](https://img.shields.io/badge/Xcode-15-blue?logo=xcode)
![License](https://img.shields.io/badge/License-MIT-green)

<!-- TODO: App Store 출시 후 아래 다운로드 배지의 링크를 실제 앱 주소로 교체해주세요. -->
<!--
<a href="https://apps.apple.com/kr/app/bookbuddy">
  <img src="https://developer.apple.com/assets/elements/badges/download-on-the-app-store.svg" alt="Download on the App Store" height="48" />
</a>
-->

</div>

---

## 📑 목차 (Table of Contents)

- [프로젝트 소개](#-프로젝트-소개)
- [주요 기능](#-주요-기능-features)
- [기술 스택](#-기술-스택-tech-stack)
- [아키텍처](#-아키텍처-architecture)
- [폴더 구조](#-폴더-구조-project-structure)
- [기술적 고민 / 트러블 슈팅](#-기술적-고민--트러블-슈팅)
- [컨벤션](#-컨벤션-convention)
- [라이브러리 의존성](#-라이브러리-의존성)

---

## 📖 프로젝트 소개

### 배경 및 동기

책을 좋아하는 사람들에게 독서는 혼자만의 경험에 머무는 경우가 많습니다. 좋은 책을 읽고 나서 **누군가와 감상을 나누고, 취향이 비슷한 사람을 발견하고 싶은 순간**이 있지만, 기존 독서 앱은 대부분 개인의 독서 기록·서재 관리에 초점이 맞춰져 있어 "사람과 사람을 잇는" 경험은 부족했습니다.

**BookBuddy**는 이 지점에서 출발했습니다.
관심 있는 책을 검색해 감상을 담은 글을 작성하고, 다른 사용자를 팔로우하며, 좋아요와 댓글로 소통하는 **책 기반 소셜 커뮤니티 앱**입니다. 홈 피드에서는 내가 팔로우한 사람들의 글이 흐르고, 새로운 좋아요·댓글·팔로우는 실시간 푸시 알림으로 전달됩니다.

### 핵심 가치

- **책 중심의 소통(Book-Centered)**: 네이버 책 검색 API로 실제 도서 정보를 불러와 글에 첨부, 대화의 맥락을 책으로 고정
- **관계 기반 피드(Social Feed)**: 팔로우한 사용자의 게시글로 구성되는 홈 타임라인
- **실시간 상호작용**: 좋아요 · 댓글 · 팔로우 이벤트를 FCM 푸시 알림으로 즉시 전달
- **반응형 UX**: RxSwift 기반의 선언적 바인딩과 SkeletonView 로딩 처리로 매끄러운 사용 경험

---

## ✨ 주요 기능 (Features)

> 💡 각 기능의 실제 동작 스크린샷은 추후 추가될 예정입니다.

| 기능 | 설명 |
|------|------|
| 📚 **책 검색** | 네이버 책 검색 API로 도서를 조회하고, SwiftSoup으로 상세 정보를 파싱해 글에 첨부 |
| 🔍 **둘러보기 / 검색** | 게시글·사용자 검색, 팔로우, 최근 검색어를 로컬(UserDefaults) 저장 |
| 🏠 **홈 피드** | 팔로우한 사용자들의 게시글을 모아 보여주는 타임라인, 좋아요 토글 |
| ✏️ **글 작성 / 수정 / 삭제** | 책 정보와 감상을 담은 게시글 작성 및 편집 |
| 💬 **댓글** | 게시글에 댓글 작성·삭제 (SwipeCellKit 스와이프 삭제) |
| ❤️ **좋아요 & 팔로우** | 게시글 좋아요, 사용자 팔로우/팔로잉 관리 |
| 🔔 **푸시 알림** | 좋아요·댓글·팔로우 발생 시 FCM(Firebase Cloud Messaging) 실시간 알림 |
| 👤 **계정 / 프로필** | 닉네임·비밀번호 로그인, 이메일 회원가입, Apple 로그인, 프로필·관심 도서 편집 |
| 🚨 **신고** | 부적절한 게시글·사용자 신고 기능 |

<!-- TODO: 아래 자리에 기능별 스크린샷 이미지를 추가해주세요.
예시:
| 책 검색 | 홈 피드 | 글 작성 |
|:---:|:---:|:---:|
| <img src="images/search.png" width="200"/> | <img src="images/home.png" width="200"/> | <img src="images/write.png" width="200"/> |
-->

---

## 🛠 기술 스택 (Tech Stack)

| 카테고리 | 사용 기술 |
|---------|----------|
| **Language** | Swift 5.0 |
| **Minimum iOS** | iOS 17.0 |
| **UI** | UIKit (Code-based, No Storyboard) |
| **Architecture** | MVVM |
| **Reactive** | RxSwift, RxCocoa |
| **Networking** | URLSession (제네릭 래퍼) |
| **Local Storage** | UserDefaults (세션 · 프로필 · 최근 검색어) |
| **Push / Backend SDK** | Firebase Cloud Messaging |
| **Auth** | Nickname/Password, Sign in with Apple, 이메일 인증(SwiftSMTP) |
| **External API** | Naver 책 검색 API + SwiftSoup(HTML 파싱) |
| **Dependency Manager** | Swift Package Manager (SPM) |
| **CI/CD** | - (추후 Fastlane / GitHub Actions 도입 예정) |

---

## 🏗 아키텍처 (Architecture)

### MVVM + RxSwift

```
┌────────────────────┐      bind       ┌────────────────────┐      request      ┌────────────────────┐
│  ViewController    │ ───────────────▶ │      ViewModel     │ ────────────────▶ │   Service Layer    │
│  (View Layer)      │ ◀─────────────── │ (Business Logic)   │ ◀──────────────── │ (Network / URLSession)│
│  - Layout          │   Observable    │  - RxSubject       │   completion / DTO│  - BoardService    │
│  - User Input      │                 │  - DTO → Domain    │                   │  - MemberService   │
└────────────────────┘                 └────────────────────┘                   └────────────────────┘
                                                                                          │
                                                                                          ▼
                                                                          Backend REST API / Naver API
```

### 레이어별 역할

- **View Layer (`ViewController` + `View`)**
  - 사용자 입력을 받아 ViewModel의 메서드를 호출
  - ViewModel의 `Observable`(`BehaviorSubject`/`PublishSubject`)을 구독하여 UI 갱신
  - 레이아웃은 모두 코드 기반(programmatic), SkeletonView로 로딩 상태 처리

- **ViewModel Layer (`ViewModel`)**
  - 비즈니스 로직과 상태 관리, `Service`를 통해 네트워크 호출
  - 서버 응답 `DTO`를 화면 친화적인 `Domain`(`~Information`) 모델로 변환
  - Rx Subject로 View에 데이터 스트림 제공

- **Service Layer (`Network/*Service`)**
  - 도메인별 API 호출을 담당(`BoardService`, `CommentService`, `MemberService`, `NotificationService`, `FollowingService`)
  - 공용 `NetworkSessionManager`의 제네릭 GET/POST/DELETE 메서드를 사용

- **Model 계층 (`DTO` ↔ `Domain`)**
  - `DTO`: 서버 통신 전용 `Codable` 모델 (`Network/*/DTO`)
  - `Domain`(`~Information`): View/ViewModel이 다루는 순수 모델 (`*/Domain`)

### 네트워크 계층

```swift
// Util/Network/NetworkSessionManager.swift
final class NetworkSessionManager {
    private let BaseURL = Bundle.main.infoDictionary?["Server_URL"] as? String

    func urlGetMethod<T: Codable>(path: String, requestDTO: T.Type,
                                  completion: @escaping (Result<T, Error>) -> Void) { ... }
    func urlPostMethod<T: Codable>(path: String, encodeValue: T,
                                   completion: @escaping (Bool) -> Void) { ... }
    func urlDeleteMethod<T: Codable>(path: String, encodeValue: T,
                                     completion: @escaping (Bool) -> Void) { ... }
}
```

- `Server_URL`, `API_URL`, `Client_Id` 등 민감 정보는 코드에 하드코딩하지 않고 **`Info.plist`(빌드 설정)**에서 주입받습니다.
- HTTP 메서드는 매직 스트링 대신 `enum HTTPMethod`(`GET`/`POST`/`DELETE`)로 관리합니다.

### 왜 MVVM + RxSwift인가?

- **View ↔ 로직 분리**: `HomeViewController`는 저장/조회 로직을 몰라도 `HomeViewModel.getFollowingBoards()` 호출만으로 피드를 갱신합니다.
- **반응형 UI 갱신**: 서버 응답이 도착하면 `isUploadedFollowingBoardInfo.onNext("setValue")` 한 줄로 View가 자동 갱신됩니다.
- **테스트 용이성**: ViewModel이 UIKit에 최소한으로 의존해 단위 테스트 작성이 수월합니다.

---

## 📂 폴더 구조 (Project Structure)

```
BookBuddy/
├── AppDelegate.swift              # Firebase / FCM 초기화, APNs 등록
├── SceneDelegate.swift
├── MainTabBarController.swift     # 5개 탭 컨테이너
├── Info.plist
├── GoogleService-Info.plist       # Firebase 설정
│
├── BookSearch/                    # [탭] 책 검색하기 (Naver API + SwiftSoup)
│   ├── View/  ├── ViewController/
│   ├── ViewModel/  ├── Domain/  └── ReqeustDTO/
│
├── BoardSearch/                   # [탭] 둘러보기 / 검색
│   ├── View/  ├── ViewController/  ├── ViewModel/  ├── Domain/
│   └── CoreData/                  # RecentSearch 데이터 모델 (실 저장은 UserDefaults 사용)
│
├── Home/                          # [탭] 홈 피드 (팔로잉 타임라인)
│   ├── ViewController/  ├── ViewModel/  └── Domain/
│
├── BoardWrite/                    # [탭] 글 작성 / 수정
│   ├── View/  ├── ViewController/  ├── ViewModel/  └── Domain/
│
├── Member/                        # [탭] 내 계정
│   ├── Signin/                    # 닉네임·비밀번호 / Apple 로그인
│   ├── Signup/                    # 이메일 회원가입 (SMTP 인증)
│   ├── Edit/                      # 프로필·관심도서 편집
│   └── Activity/                  # 내 활동 / 회원 정보
│
├── Comment/                       # 댓글 작성·삭제
│   ├── View/  ├── ViewController/  ├── ViewModel/  └── Domain/
│
├── Notification/                  # 알림 목록 화면
├── Report/                        # 신고 기능
│
├── Network/                       # Service 계층 + DTO
│   ├── Board/  (Service + DTO: Write/Search/Edit/Following/Like)
│   ├── Comment/  ├── Member/  └── Notification/
│
├── Util/
│   ├── Network/                   # NetworkSessionManager (제네릭 URLSession)
│   ├── Enum/                      # HTTPMethod, UserDefaultsForkey, MailAddress 등
│   ├── Protocol/  ├── Controller/
│
├── Extension/                     # UIView+, String+, Date+ 등
├── Assets.xcassets/
└── Base.lproj/
```

---

## 💡 기술적 고민 / 트러블 슈팅

### 1. 외부 API 응답의 한계를 SwiftSoup 크롤링으로 보완

- **문제 상황**
  네이버 책 검색 API는 제목·저자·링크 등 기본 메타데이터만 제공할 뿐, 사용자가 글에 담고 싶어 하는 **풍부한 책 소개/상세 정보**가 부족했습니다. API 결과만으로는 게시글의 정보량이 빈약해지는 문제가 있었습니다.

- **원인 분석**
  검색 API의 목적은 "검색 결과 리스트"에 최적화되어 있어, 항목별 상세 페이지 콘텐츠까지 내려주지 않습니다. 필요한 상세 정보는 각 도서의 상세 `link` 페이지(HTML)에만 존재했습니다.

- **해결 방법**
  검색 API로 얻은 각 도서의 `link`를 대상으로 **SwiftSoup으로 상세 페이지 HTML을 파싱(crawling)**하여 부족한 정보를 채우고, 이를 하나의 도메인 모델로 합쳐 View에 전달했습니다.

  ```swift
  // BookSearch/ViewModel/BookSearchViewModel.swift
  request.addValue(clientID, forHTTPHeaderField: "X-Naver-Client-Id")
  request.addValue(clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
  // ... 검색 결과의 link 목록을 SwiftSoup으로 재파싱
  let urls = bookSearchResults.map { $0.link }
  crawling(with: urls) { result in ... }
  ```

- **결과**
  - API가 제공하지 못하는 상세 정보까지 확보해, 글에 첨부되는 책 카드의 정보량이 크게 늘었습니다.
  - 검색 → 상세 파싱 흐름을 ViewModel에 캡슐화해 View는 최종 결과만 구독하면 되도록 단순화했습니다.

  <!-- TODO: 파싱 대상 필드/평균 응답 시간 등 정량 지표가 있다면 추가해주세요. -->

---

### 2. 도메인별 Service 분리와 제네릭 네트워크 래퍼

- **문제 상황**
  게시글·댓글·회원·알림 등 API 호출 지점이 늘어나면서, 각 호출마다 `URLRequest` 생성 → 메서드 설정 → 인코딩/디코딩 → 에러 처리 코드가 반복 작성되어 중복이 심해졌습니다.

- **원인 분석**
  HTTP 통신의 "형태"(GET/POST/DELETE + Codable 직렬화)는 도메인이 달라도 동일한데, 이를 도메인 코드마다 반복하고 있었습니다. 공통 로직과 도메인 로직이 분리되지 않은 상태였습니다.

- **해결 방법**
  제네릭 기반의 `NetworkSessionManager`로 GET/POST/DELETE 통신을 일원화하고, 도메인별 `Service`(`BoardService`, `CommentService`, `MemberService` 등)가 `path`와 `DTO`만 넘기도록 설계했습니다. `BaseURL`은 `Info.plist`에서 주입받아 코드와 분리했습니다.

  ```swift
  func urlPostMethod<T: Codable>(path: String, encodeValue: T,
                                 completion: @escaping (Bool) -> Void) {
      guard let BaseURL, let url = URL(string: BaseURL + path) else { return }
      // 공통 인코딩 · 요청 · 에러 처리
  }
  ```

- **결과**
  - Service는 "무엇을 호출하는지"(path·DTO)에만 집중하고, "어떻게 호출하는지"는 한 곳에서 관리됩니다.
  - 새로운 API 추가 시 보일러플레이트 없이 Service 메서드 한 개만 추가하면 되도록 개발 생산성이 향상되었습니다.

---

## 📏 컨벤션 (Convention)

### Git Flow / Branch 전략

```
main       ──●───────────────────●──────────●──▶  (App Store 배포)
              ╲                 ╱           ╲
release        ●───────────────●             ●──▶  (QA / 릴리즈 후보)
                ╲             ╱
develop         ●──●──●──●──●─●──▶  (통합 개발)
                    │  │  │
feature/*          ●──●  │         (기능 단위 브랜치)
fix/*              ────── ●         (버그 수정 브랜치)
```

- `main`: 스토어 배포 반영 브랜치
- `develop`: 통합 개발 브랜치
- `feature_{기능명}`: 신규 기능 개발 (예: `feature_notification`, `feature_board_write_redesign`)
- `fix_{대상}`: 버그 수정 (예: `fix_notification_typo`)

### Commit 메시지 규칙

타입 + 대상 순으로 작성하며, PR 병합 및 리뷰 피드백 반영 이력을 남깁니다.

| 이모지 | 타입 | 사용 예시 |
|:---:|---|---|
| ✨ | `feat` | ✨ feat: 글 작성 화면 디자인 개편 |
| 🔧 | `fix` | 🔧 fix: 알림 누락 및 디코딩 오류 수정 |
| ♻️ | `refactor` | ♻️ refactor: 네트워크 계층 정리 |
| 📝 | `docs` | 📝 docs: Update README |

### 코드 컨벤션

- **네이밍**: Swift API Design Guidelines 준수
- **레이아웃**: 모든 UI는 **코드 기반(programmatic)**으로 작성, Storyboard 사용 금지
- **접근 제어**: 기본적으로 `private`, 외부 노출이 필요한 경우에만 명시적으로 상향
- **타입 안전성**: 매직 스트링 대신 `enum`(예: `HTTPMethod`, `UserDefaultsForkey`, `MailAddress`) 사용
- **모델 분리**: 서버 통신용 `DTO`와 화면용 `Domain(~Information)` 모델을 명확히 구분
- **보안**: `Server_URL` · API 키 등 민감 정보는 `Info.plist`(빌드 설정)로 주입하고 소스에 하드코딩하지 않음
- **파일 구조**: 기능 단위로 `ViewController` / `View` / `ViewModel` / `Domain` 하위 폴더 분리

---

## 📦 라이브러리 의존성

모든 외부 의존성은 **Swift Package Manager (SPM)**로 관리됩니다.

| 라이브러리 | 선택 이유 |
|-----------|----------|
| **[RxSwift / RxCocoa](https://github.com/ReactiveX/RxSwift)** | ViewModel ↔ View 간 데이터 바인딩을 선언적으로 표현하고, 비동기 네트워크 결과를 스트림으로 처리하기 위해 도입. |
| **[Firebase (Cloud Messaging)](https://github.com/firebase/firebase-ios-sdk)** | 좋아요·댓글·팔로우 이벤트에 대한 실시간 푸시 알림(FCM)을 구현하기 위해 사용. |
| **[SwiftSoup](https://github.com/scinfu/SwiftSoup)** | 네이버 책 검색 API가 제공하지 않는 상세 정보를 도서 페이지 HTML에서 파싱하기 위해 도입. |
| **[SkeletonView](https://github.com/Juanpe/SkeletonView)** | 피드·검색 결과 로딩 중 스켈레톤 UI를 표시해 체감 대기 시간을 줄이기 위해 사용. |
| **[SwipeCellKit](https://github.com/SwipeCellKit/SwipeCellKit)** | 댓글·목록 셀에서 스와이프 제스처 기반 삭제 액션을 구현하기 위해 사용. |
| **[Swift-SMTP](https://github.com/IBM-Swift/Swift-SMTP)** | 이메일 회원가입 시 인증 코드를 발송하는 이메일 인증 플로우를 위해 도입. |

---

<div align="center">

Made with 📚 by [@haansohee](https://github.com/haansohee)

</div>
