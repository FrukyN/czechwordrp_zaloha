// These are the jobs that can create documents. The ranks in templateGrades can create templates for this job.
const AVAILABLE_JOBS = [
  {
    job: 'police',
    templateGrades: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16],
    logo: '/web/src/assets/city_logo.png',
  },
  {
    job: 'ambulance',
    templateGrades: [1,2,3,4,5,6,7,8,9,10,11,12],
    logo: '/web/src/assets/city_logo.png',
  },
  {
    job: 'mechanic',
    templateGrades: [1,2,3,4,5],
    logo: '/web/build/mechaniclogo.jpg',
  },
  {
    job: 'hzs',
    templateGrades: [1,2,3,4,5,6,7,8,9,10,11,12],
    logo: '/web/build/HZS.png',
  },
  {
    job: 'wine',
    templateGrades: [1,2,3,4],
    logo: '/web/build/vinice.png',
  },
    {
    job: 'stk',
    templateGrades: [1,2,3,4],
    logo: '/web/build/mechaniclogo.jpg',
  },
  {
    job: 'gibs',
    templateGrades: [1,2,3],
    logo: '/web/build/GI.png',
  },
]

// These templates are visible to all players. If you don't want
// any citizen templates, delete everything inside the [] like this:
//    const CITIZEN_TEMPLATES = []
//
// If these templates are empty, the issued documents tab will
// not be visible to players who fon't have a specified job.
const CITIZEN_TEMPLATES = [
  {
    id: 'citizen_contract',
    documentName: 'Občanská smlouva',
    documnetDescription:
      'Toto je dokument mezi dvěma občany České Republiky. Tento dokument je oficiální právní dokument.',
    fields: [
      {
        name: 'Jmeno',
        value: '',
      },
      {
        name: 'Prijmeni',
        value: '',
      },
      {
        name: 'Platné do',
        value: '',
      },
    ],
    infoName: 'Informace',
    infoTemplate: '',
  },
]
const JOB_TEMPLATES = {
  wine: [
    {
      id: 'wine_contract',
      documentName: 'Prodejní smlouva',
      documentDescription: 'Toto je dokument mezi firmami České Republiky. Tento dokument je oficiální právní dokument.',
      fields: [
        { name: 'Jméno', value: '' },
        { name: 'Příjmení', value: '' },
        { name: 'Platné do', value: '' },
      ],
      infoName: 'Informace',
      infoTemplate: '',
    },
  ],

  police: [
    {
      id: 'police_report',
      documentName: 'Policejní protokol',
      documentDescription: 'Oficiální protokol Policie České republiky.',
      fields: [
        { name: 'Jméno pachatele', value: '' },
        { name: 'Příjmení pachatele', value: '' },
        { name: 'Datum události', value: '' },
        { name: 'Popis incidentu', value: '' },
      ],
      infoName: 'Poznámky',
      infoTemplate: '',
    },
  ],

  ambulance: [
    {
      id: 'medical_report',
      documentName: 'Zdravotní zpráva',
      documentDescription: 'Oficiální lékařská zpráva vydaná Zdravotnickou záchrannou službou.',
      fields: [
        { name: 'Jméno pacienta', value: '' },
        { name: 'Příjmení pacienta', value: '' },
        { name: 'Datum vyšetření', value: '' },
        { name: 'Diagnóza', value: '' },
        { name: 'Doporučená léčba', value: '' },
      ],
      infoName: 'Další informace',
      infoTemplate: '',
    },
  ],

  mechanic: [
    {
      id: 'mechanic_order',
      documentName: 'Zakázkový list',
      documentDescription: 'Dokument o opravě nebo údržbě vozidla vydaný autoservisem.',
      fields: [
        { name: 'Jméno zákazníka', value: '' },
        { name: 'Příjmení zákazníka', value: '' },
        { name: 'SPZ vozidla', value: '' },
        { name: 'Popis závady', value: '' },
        { name: 'Prováděné opravy', value: '' },
      ],
      infoName: 'Dodatečné poznámky',
      infoTemplate: '',
    },
  ],
  
    stk: [
    {
      id: 'stk_order',
      documentName: 'STK vozidla',
      documentDescription: 'Dokument o opravě nebo údržbě vozidla vydaný STK s.r.o',
      fields: [
        { name: 'Jméno zákazníka', value: '' },
        { name: 'Příjmení zákazníka', value: '' },
        { name: 'SPZ vozidla', value: '' },
        { name: 'Popis závady', value: '' },
        { name: 'Prováděné opravy', value: '' },
      ],
      infoName: 'Dodatečné poznámky',
      infoTemplate: '',
    },
  ],

  hzs: [
    {
      id: 'hzs_report',
      documentName: 'Zásahový protokol',
      documentDescription: 'Oficiální protokol Hasičského záchranného sboru České republiky.',
      fields: [
        { name: 'Datum zásahu', value: '' },
        { name: 'Místo zásahu', value: '' },
        { name: 'Druh události', value: '' },
        { name: 'Průběh zásahu', value: '' },
        { name: 'Použitá technika', value: '' },
      ],
      infoName: 'Záznam velitele',
      infoTemplate: '',
    },
  ],
}

const COLORS = {
  // These are hexadecimal color codes for the main theme. You can change them as you wish.
  // Primary colors are colors of buttons, and some texts, while secondary color is used for the cancel button.
  primary: '#E37777',
  secondary: '#DCAF62',

  // These two should stay RGBA to give them a 90% opacity. Only change the first 3 numbers with any RGB code
  // i.e. rgba([red], [green], [blue], 0.9)
  menuGradientBottom: 'rgba(209, 142, 142, 0.9)',
  menuGradientTop: 'rgba(243, 243, 203, 0.9)',
}

// These are the texts that show up on the NUI. Translate them as you wish. If you'd like to change
// the client texts, go to the config.lua file.

const TEXTS = {
  myDocumentsTitle: 'Moje dokumenty',
  issuedDocumentsTitle: 'Vydané dokumenty',
  templatesTitle: 'Šablony',
  customDocumentName: 'Název dokumentu',
  documentType: 'Typ',
  documentName: 'Název',
  unnamed: 'Nepojmenovaný',
  actions: 'Akce',
  edit: 'Upravit',
  cancel: 'Zrušit',
  delete: 'Smazat',
  view: 'Zobrazit',
  show: 'Ukázat',
  copy: 'Kopírovat',
  newTemplateBtn: 'Nová šablona',
  deleteTemplateTitle: 'Smazat šablonu',
  deleteTemplateQuestion: 'Opravdu chcete smazat tuto šablonu?:',
  date: 'Datum',
  newDocumentBtn: 'Nový dokument',
  newCitizenDocumentBtn: 'Nový občanský dokument',
  deleteDocumentTitle: 'Smazat dokument',
  deleteDocumentQuestion: 'Opravdu chcete smazat tento dokument?:',
  signHereText: 'Podepište zde',
  selectDocumentType: 'Vyberte typ dokumentu',
  cannotIssueDocument: 'S tímto zaměstnáním nemůžete vydávat dokumenty',
  issuerFirstname: 'JMÉNO VYDAVATELE',
  issuerLastname: 'PŘÍJMENÍ VYDAVATELE',
  issuerDOB: 'DATUM NAROZENÍ VYDAVATELE',
  issuerJob: 'POVOLÁNÍ VYDAVATELE',
  termsAndSigning: 'PODMÍNKY A PODPIS',
  terms1: 'Tento dokument se po podepsání stává oficiálním dokumentem.',
  terms2: 'Podepsáním tohoto dokumentu se právně zavazujete k jeho obsahu a přijímáte veškeré právní důsledky, které může vyvolat.',
  terms3: 'Každá kopie tohoto dokumentu má stejnou hodnotu jako originál. Dávejte si zvláštní pozor při předávání kopií.',
  terms4: 'Ujistěte se, že si jste plně vědomi obsahu tohoto dokumentu, než podepíšete.',
  terms5: 'Neváhejte vyhledat právní radu před podpisem.',
  requiredError: 'Toto pole je povinné',
  docNameField: 'NÁZEV DOKUMENTU',
  docDescField: 'POPIS DOKUMENTU',
  docFieldField: 'NÁZEV POLE',
  docAddField: 'Přidat pole',
  docInfoNameField: 'NÁZEV INFORMACE',
  docInfoValueField: 'ŠABLONA INFORMACE',
  docMinGradeField: 'MINIMÁLNÍ HODNOST PRÁCE',
  editTemplateBtn: 'UPRAVIT ŠABLONU',
  createTemplateBtn: 'VYTVOŘIT ŠABLONU',
  createDocumentBtn: 'VYTVOŘIT DOKUMENT',
  documentCopy: 'KOPIE',
}