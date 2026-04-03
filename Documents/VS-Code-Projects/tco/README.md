# t.Co. — Personal AI Travel Concierge

> פרויקט גמר לתואר שני בעיצוב לסביבה טכנולוגית  
> דוד קסטיאל | מכון טכנולוגי חולון HIT | תערוכה: 6–19 אוגוסט 2026

---

## מבנה ה-repo

```
tco-project/
│
├── index.html                      ← דף הבית
│
├── pages/
│   ├── project-plan.html           ← תכנית הפרויקט האינטראקטיבית
│   ├── agents.html                 ← דיאגרמת הסוכנים
│   ├── design-system.html          ← עמוד Design System
│   └── exhibition.html             ← מידע על התערוכה
│
├── assets/
│   ├── css/
│   │   └── tco-design.css          ← Design System — כל הצבעים, גופנים, קומפוננטות
│   ├── fonts/                      ← גופנים self-hosted (אופציונלי)
│   └── icons/                      ← SVG icons
│
├── docs/
│   ├── tco_project_book_v2.pdf     ← ספר הפרויקט
│   └── tco_project_plan.xlsx       ← קובץ תכנון הפרויקט
│
├── deliverables/                   ← כל תוצר שנבנה בפרויקט
│   └── YYYY-MM-DD_deliverable.html ← שם קובץ = תאריך + תיאור
│
└── README.md
```

---

## Design System

כל דף HTML בפרויקט מייבא:

```html
<link rel="stylesheet" href="../assets/css/tco-design.css">
```

### פלטת צבעים

| שם | Hex | שימוש |
|---|---|---|
| Navy | `#0B1D3A` | כותרות, רקע header |
| Blue Mid | `#1A3F72` | כותרות מקטע |
| Blue Soft | `#2E6AAF` | קווים, borders |
| Blue Pale | `#E8F0FA` | שורות לסירוגין |
| Crimson | `#C0272D` | accent, labels |

### גופנים

- **Latin / UI:** Poppins (Light · Regular · Medium · Bold)
- **עברית:** Noto Sans Hebrew (Light · SemiBold)
- **Mono:** JetBrains Mono

### ערכות נושא

כל דף תומך ב-3 ערכות: `light` / `dark` / `system`.  
הבחירה נשמרת ב-`localStorage` תחת המפתח `tco-theme`.

---

## הוספת תוצר חדש

1. צור קובץ ב-`deliverables/` בפורמט `YYYY-MM-DD_שם-תוצר.html`
2. בראש הקובץ הוסף:
   ```html
   <link rel="stylesheet" href="../assets/css/tco-design.css">
   ```
3. הוסף שורה לטבלת התוצרים ב-`index.html`
4. העלה ל-repo

---

## GitHub Pages

האתר מתפרסם אוטומטית מה-branch `main`.  
כתובת: `https://[username].github.io/[repo-name]/`

להפעלה: **Settings → Pages → Source: main / root**

---

## פרטי הפרויקט

| | |
|---|---|
| **שם** | t.Co. — Personal AI Travel Concierge |
| **סטודנט** | דוד קסטיאל |
| **מוסד** | מכון טכנולוגי חולון HIT |
| **תואר** | M.Design בעיצוב לסביבה טכנולוגית |
| **הגשה** | 4 אוגוסט 2026 |
| **תערוכה** | 6–19 אוגוסט 2026 |
