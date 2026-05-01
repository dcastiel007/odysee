# t.Co. — Personal AI Travel Concierge

> פרויקט גמר לתואר שני בעיצוב לסביבה טכנולוגית  
> דוד קסטיאל | מכון טכנולוגי חולון HIT | תערוכה: 6–19 אוגוסט 2026

🌐 **Live site:** https://tico.mytico.me

---

## מבנה ה-repo

```
tco-project/
│
├── index.html                          ← דף הבית — hero, timeline, טבלת תוצרים
│
├── pages/
│   ├── agents.html                     ← ארכיטקטורה — 11 סוכנים, stack, תרשים
│   ├── project-plan.html               ← תכנית פרויקט — Gantt chart, 7 פאזות
│   ├── ux-flows.html                   ← UX Flows — Personas, Journey, Flows, IA
│   ├── design-system.html              ← Brand Identity & Design System
│   ├── onboarding.html                 ← Onboarding Dialogue Flows + prototype חי
│   ├── exhibition.html                 ← מידע על התערוכה
│   └── _template.html                  ← תבנית לדפים חדשים
│
├── assets/
│   ├── css/
│   │   └── tco-design.css             ← Design System מרכזי
│   └── icons/
│       ├── tco-mark.svg               ← Globe Mark — סמל גרפי
│       └── tco-wordmark.svg           ← Horizontal lockup
│
├── docs/
│   ├── tco_architecture_v2.0.pdf/docx  ← מסמך ארכיטקטורה
│   ├── tco_project_book_v2.0.pdf       ← ספר הפרויקט האקדמי
│   ├── tco_ux-flows_v1.0.pdf/docx      ← UX Flows + Personas
│   ├── tco_design-system_v1.0.pdf/docx ← Brand Identity & Design System
│   ├── tco_onboarding_v1.0.pdf/docx    ← Onboarding Dialogue Flows
│   └── ticoprojectplanv1.xlsx          ← קובץ תכנון הפרויקט
│
└── README.md
```

---

## תוצרים

| תוצר | פורמטים | גרסה |
|------|----------|-------|
| ארכיטקטורת המערכת | HTML · PDF · DOCX | v2.0 |
| ספר הפרויקט | PDF | v2.0 |
| UX Flows + Personas | HTML · PDF · DOCX | v1.0 |
| Brand Identity & Design System | HTML · PDF · DOCX | v1.0 |
| Onboarding Dialogue Flows | HTML · PDF · DOCX | v1.0 |
| תכנית פרויקט (Gantt) | HTML · XLSX | v1.0 |

---

## Design System

כל דף HTML מייבא את מערכת העיצוב:

```html
<link rel="stylesheet" href="../assets/css/tco-design.css">
```

### פלטת צבעים

| שם | Hex | שימוש |
|---|---|---|
| Background | `#0A0A0F` | רקע דף (dark mode) |
| Surface | `#13131A` | header, footer |
| Card | `#1C2230` | כרטיסים |
| **Gold** | `#C8A96E` | accent ראשי, לוגו, CTAs |
| Teal | `#4ECDC4` | אינטראקטיבי, AI indicators |
| Purple | `#7C6FCD` | Design status |

### גופנים

- **Latin / UI:** Poppins (300 · 400 · 500 · 700)
- **עברית:** Noto Sans Hebrew (300 · 600)
- **Mono:** JetBrains Mono

---

## ארכיטקטורת המערכת

11 סוכני AI מתמחים בארבעה שלבי נסיעה:

| שלב | סוכנים |
|------|--------|
| Before Trip | AGT-01 Profiling · AGT-02 Itinerary · AGT-03 Booking |
| During Trip | AGT-04 Location · AGT-05 Schedule · AGT-06 Language |
| Post Trip | AGT-07 Memory · AGT-08 Feedback |
| Long-Term | AGT-09 Loyalty · AGT-10 Analytics · AGT-11 Anticipation |

**Stack:** LangGraph · Claude AI · RAG · ChromaDB · FastAPI · React

---

## הגשה

- **תאריך הגשה:** 4 אוגוסט 2026  
- **תערוכה:** 6–19 אוגוסט 2026  
- **מוסד:** HIT — המכון הטכנולוגי חולון  
- **תואר:** M.Design — Design for Technological Environments
