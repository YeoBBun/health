# 맨몸 운동 — APK 만들기

`app` 폴더 안의 파일을 GitHub에 올려 웹 주소를 만들고, 그 주소로 APK를 뽑는 순서입니다.
APK는 안드로이드 전용이라 아이폰이면 이 방법은 쓸 수 없습니다.

## 폴더 구성

```
app/
  index.html      앱 본체
  manifest.json   앱 이름·아이콘·전체화면 설정
  sw.js           오프라인 동작용
  .nojekyll       GitHub Pages가 숨김 폴더를 무시하지 않게 함
  icons/
    icon-192.png
    icon-512.png
    icon-maskable-512.png
```

`legend.html`이 원본이고, `app/index.html`은 거기서 만들어낸 결과물입니다.
앱을 고친 뒤에는 PowerShell에서 `.\build.ps1`을 실행해 다시 만들어야 합니다.

---

## 1. GitHub에 올리기

1. github.com 가입 후 로그인
2. 오른쪽 위 `+` → **New repository**
3. 이름은 `manmom-workout` 정도로, **Public** 선택 → **Create repository**
4. 만들어진 화면에서 **uploading an existing file** 클릭
5. **`app` 폴더 자체가 아니라 그 안의 내용물을** 드래그해서 올립니다
   - `index.html`, `manifest.json`, `sw.js`, `.nojekyll`, 그리고 `icons` 폴더
   - `index.html`이 저장소 맨 위에 있어야 합니다
6. 아래 **Commit changes** 클릭

> `.nojekyll` 파일이 안 올라가면 나중에 5단계에서 막힙니다. 숨김 파일이라 탐색기에서
> 안 보이면, 탐색기 상단 **보기 → 숨긴 항목** 체크를 켜세요.

## 2. 웹 주소 켜기

1. 저장소 상단 **Settings** → 왼쪽 메뉴 **Pages**
2. Source를 **Deploy from a branch**, Branch를 **main / (root)** 으로 두고 **Save**
3. 1~2분 기다리면 주소가 나옵니다

```
https://<본인아이디>.github.io/manmom-workout/
```

폰에서 이 주소를 열어 앱이 제대로 뜨는지 먼저 확인하세요.

> 여기서 **크롬 메뉴(⋮)에 "앱 설치"가 뜬다면 APK 없이 끝낼 수 있습니다.**
> 지금까지 홈 화면 추가가 안 됐던 건 아티팩트 주소에 앱 설정 파일이 없어서일 가능성이 큽니다.
> 설치가 되면 아이콘·전체화면·오프라인이 전부 APK와 똑같이 동작합니다.

## 3. PWABuilder로 APK 뽑기

2단계 주소로 "앱 설치"가 안 뜰 때만 하면 됩니다.

1. [pwabuilder.com](https://www.pwabuilder.com) 접속
2. 2단계 주소를 넣고 **Start**
3. 점검 결과가 나오면 **Package For Stores** → **Android** 선택
4. 설정
   - **Package ID**: `com.본인아이디.manmom` 처럼 아무거나. 나중에 바꾸면 다른 앱으로 취급되니 한 번 정하면 고정
   - **Signing key**: **New** 선택
5. **Download** 하면 zip 파일이 받아집니다

> zip 안의 **서명 키 파일(.keystore)과 비밀번호를 반드시 따로 보관하세요.**
> 나중에 앱을 업데이트할 때 같은 키가 없으면 기존 앱 위에 덮어쓸 수 없고,
> 지우고 새로 깔아야 해서 **저장된 운동 기록이 전부 날아갑니다.**

## 4. 폰에 설치

1. zip 안의 `app-release-signed.apk`를 폰으로 옮깁니다 (USB, 카톡 나에게 보내기, 드라이브 등)
2. 폰에서 파일을 눌러 설치
3. "출처를 알 수 없는 앱" 경고가 뜨면 허용해줘야 설치됩니다

## 5. 주소 표시줄 없애기 (선택)

이 단계를 건너뛰면 앱을 켤 때마다 위쪽에 주소 표시줄이 잠깐 보입니다. 동작에는 문제없습니다.

1. 3단계에서 받은 zip 안에서 `assetlinks.json` 을 찾습니다
2. GitHub 저장소에서 **Add file → Create new file**
3. 파일 이름 칸에 `.well-known/assetlinks.json` 을 그대로 입력 (슬래시를 치면 폴더가 만들어집니다)
4. `assetlinks.json` 내용을 붙여넣고 **Commit**
5. 앱을 지웠다가 다시 설치

---

## 알아둘 것

**기록은 폰 안에만 저장됩니다.** 지금 아티팩트 버전은 서버에 저장되지만, GitHub Pages로
옮기면 그 기능이 없어집니다. 대신 앱 안에 백업이 들어 있습니다.

- 설정 → 데이터 · 저장 → **파일로 저장**: 전체 기록을 JSON 파일로 내려받기
- 같은 화면의 **파일에서 불러오기**로 복원

**앱을 지우면 기록도 같이 사라집니다.** 한 달에 한 번쯤 파일로 저장해서 드라이브나
메일에 보관해두세요.

## 앱을 고쳤을 때

1. `legend.html` 수정
2. PowerShell에서 `.\build.ps1` 실행 → `app/index.html` 갱신
3. 새 `index.html`을 GitHub에 다시 올리기 (기존 파일 위에 업로드하면 덮어써집니다)

APK를 다시 만들 필요는 없습니다. 앱이 열릴 때 GitHub에서 최신 내용을 받아옵니다.

아이콘 모양을 바꾸려면 `make-icons.ps1`을 고쳐서 실행하면 됩니다.
