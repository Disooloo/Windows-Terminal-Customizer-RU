# Windows Terminal Customizer RU

Кастомизатор **Windows Terminal** и приглашения **Oh My Posh** для Windows.

**Автор:** Disooloo

---

## Описание

Утилита с русским меню для быстрого оформления терминала:

- готовые цветовые темы Windows Terminal (фон, шрифт, прозрачность, курсор);
- установка **JetBrainsMono Nerd Font** (кириллица + латиница, иконки);
- установка / обновление **Oh My Posh** через winget;
- выбор темы приглашения Oh My Posh с поиском и постраничным списком;
- восстановление исходных настроек из резервной копии.

Темы окна Terminal и темы Oh My Posh — это разные вещи:

| Что | За что отвечает |
| --- | --- |
| Темы Windows Terminal | Цвета, фон, шрифт, прозрачность окна |
| Темы Oh My Posh | Вид строки приглашения PowerShell (путь, Git, статус) |

---

## Требования

- Windows 10 / 11
- [Windows Terminal](https://aka.ms/terminal)
- PowerShell 5.1+ (встроен в Windows)
- Интернет — для установки шрифта и Oh My Posh
- [winget](https://aka.ms/getwinget) (App Installer из Microsoft Store) — для Oh My Posh

---

## Быстрый старт

1. Распакуйте архив **целиком** в одну папку (рядом должны быть `.ps1`, `.bat` и картинки тем).
2. Запустите **`WindowsTerminal.bat`**.
3. Выберите пункт меню.

Первый запуск Windows Terminal желателен до применения тем — так появится `settings.json`.

После смены темы Oh My Posh **полностью закройте** Windows Terminal и откройте снова.

---

## Меню

| № | Пункт | Что делает |
| --- | --- | --- |
| 1 | Установить кастомную тему Windows Terminal | Cyberpunk, Dracula, Nord, Tokyo Night, Matrix, Gruvbox, Ocean, Solarized |
| 2 | Установить шрифт JetBrainsMono Nerd Font | Нужен для иконок Oh My Posh и кириллицы |
| 3 | Выбрать тему Oh My Posh | Список локальных тем, поиск, страницы |
| 4 | Установить или обновить Oh My Posh | Через winget |
| 5 | Восстановить исходные настройки | Откат `settings.json` Windows Terminal |
| 6 | Выход | Закрыть утилиту |

---

## Как пользоваться Oh My Posh

1. Пункт **4** — установить Oh My Posh (если ещё нет).
2. Пункт **2** — поставить Nerd Font.
3. Пункт **3** — найти тему (Enter = весь список, или введите часть названия) и выбрать номер.
4. Закрыть все окна Windows Terminal и открыть новую вкладку PowerShell.

Скрипт сам:

- пишет настройки в реальный профиль PowerShell (в том числе в OneDrive «Документы»);
- включает `ExecutionPolicy RemoteSigned` для текущего пользователя;
- добавляет в профиль Windows Terminal `-ExecutionPolicy Bypass`, чтобы профиль точно загружался.

Каталог тем Oh My Posh: [ohmyposh.dev/docs/themes](https://ohmyposh.dev/docs/themes)

---

## Структура проекта

```
TerminalCustomizer_RU/
├── WindowsTerminal.bat      ← запуск
├── TerminalCustomizer.ps1   ← основное меню
├── README.md
├── README.txt
├── Cyberpunk.jpg
├── Dracula.jpg
├── Nord.jpg
├── TokyoNight.jpg
├── Matrix.jpg
├── Gruvbox.jpg
├── Ocean.jpg
└── Solarized.jpg
```

---

## Резервные копии

Перед изменением создаются файлы:

- `settings.json.terminal-customizer-backup` — рядом с настройками Windows Terminal  
- `Microsoft.PowerShell_profile.ps1.terminal-customizer-backup` — рядом с профилем PowerShell  

Пункт **5** восстанавливает только настройки Windows Terminal.

---

## Частые проблемы

**«Выполнение сценариев отключено»**  
Выберите тему Oh My Posh ещё раз через утилиту (она выставит политику) или выполните вручную:

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

Затем полностью перезапустите Windows Terminal.

**Темы Oh My Posh не находятся**  
Обычная установка через Store/winget (MSIX). Утилита ищет темы внутри пакета. Обновите Oh My Posh пунктом **4** и повторите.

**Иконки — квадратики / кракозябры**  
Установите шрифт пунктом **2** и перезапустите Terminal.

**Тема не появилась**  
Закройте все окна Terminal, не только вкладку. Откройте новый профиль PowerShell.

---

## Автор

**Disooloo**

Проект: Windows Terminal Customizer RU  
Лицензия использования: свободное личное и учебное применение. Oh My Posh, Nerd Fonts и Windows Terminal принадлежат своим авторам.
