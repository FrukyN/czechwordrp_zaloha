Locales['cs'] = {

    -- TextUI

    ['bossmenu'] = {
        text = '[E] Otevřít menu šéfa',
        color = 'darkblue',
        side = 'right'
    },

    ['dutymenu'] = {
        text = '[E] Otevřít služební menu',
        color = 'darkblue',
        side = 'right'
    },

    -- Chybová oznámení

    ['no_money'] = {
        title = "Menu šéfa",
        text = "Nemáš dostatek peněz na vložení do společnosti",
        time = 5000,
        type = 'error'
    },

    ['no_money_society'] = {
        title = "Menu šéfa",
        text = "Společnost nemá dostatek peněz",
        time = 5000,
        type = 'error'
    },

    ['target_fired_employee'] = {
        title = "Menu šéfa",
        text = "Byl jsi propuštěn z práce ${job}",
        time = 5000,
        type = 'error'
    },

    ['near_error'] = {
        title = 'Menu šéfa',
        text = 'Nikdo není poblíž',
        type = 'error',
        time = 5000,
    },

    ['same_job'] = {
        title = 'Menu šéfa',
        text = '${player} už pracuje jako ${job}',
        type = 'error',
        time = 5000,
    },

    ['cant_edit_chief'] = {
        title = 'Menu šéfa',
        text = 'Nemůžeš měnit hodnost šéfa',
        type = 'error',
        time = 5000,
    },

    ['cant_edit_self'] = {
        title = 'Menu šéfa',
        text = 'Nemůžeš měnit svou vlastní hodnost',
        type = 'error',
        time = 5000,
    },

    ['cant_fire_chief'] = {
        title = 'Menu šéfa',
        text = 'Nemůžeš vyhodit šéfa',
        type = 'error',
        time = 5000,
    },

    ['cant_fire_self'] = {
        title = 'Menu šéfa',
        text = 'Nemůžeš vyhodit sám sebe',
        type = 'error',
        time = 5000,
    },

    ['duty_ended'] = {
        title = "Menu šéfa",
        text = "Ukončil jsi službu",
        time = 5000,
        type = 'error'
    },

    ['cant_open_menu'] = {
        title = "Menu šéfa",
        text = "Nemůžeš otevřít menu, protože nejsi šéf",
        time = 5000,
        type = 'error'
    },

    -- Úspěšná oznámení

    ['deposited'] = {
        title = "Menu šéfa",
        text = "Vložil jsi ${money}" ..Config.Currency.." do společnosti ${job}",
        time = 5000,
        type = 'success'
    },
    
    ['withdrawn'] = {
        title = "Menu šéfa",
        text = "Vybral jsi ${money}" ..Config.Currency.." ze společnosti ${job}",
        time = 5000,
        type = 'success'
    },

    ['edited_employee'] = {
        title = "Menu šéfa",
        text = "Změnil jsi hodnost hráče ${player} na ${grade}",
        time = 5000,
        type = 'success'
    },

    ['target_edited_employee'] = {
        title = "Menu šéfa",
        text = "Tvoje hodnost byla změněna na ${grade}",
        time = 5000,
        type = 'success'
    },

    ['fired_employee'] = {
        title = "Menu šéfa",
        text = "Vyhodil jsi ${player} z práce ${job}",
        time = 5000,
        type = 'success'
    },

    ['hired_employee'] = {
        title = "Menu šéfa",
        text = "Najal jsi ${player} do práce ${job}",
        time = 5000,
        type = 'success'
    },

    ['target_hired_employee'] = {
        title = "Menu šéfa",
        text = "Byl jsi najat do práce ${job}",
        time = 5000,
        type = 'success'
    },

    ['duty_started'] = {
        title = "Menu šéfa",
        text = "Začal jsi službu",
        time = 5000,
        type = 'success'
    },

    ['bonus_given'] = {
        title = "Menu šéfa",
        text = "Dal jsi bonus ${money}" ..Config.Currency.." hráči ${player}",
        time = 5000,
        type = 'success'
    },

    ['bonus_received'] = {
        title = "Menu šéfa",
        text = "Dostal jsi bonus ${money}" ..Config.Currency.." od ${job}",
        time = 5000,
        type = 'success'
    },

    -- Varování

    ['no_society'] = {
        title = "Menu šéfa",
        text = "Informace o společnosti nenalezeny, ujisti se, že máš správně nastavený systém společnosti v configu a že společnost existuje v databázi",
        time = 5000,
        type = 'warning'
    },

    -- Překlady menu

    ['translations'] = {
        overview = "Přehled",
        employees = "Zaměstnanci",
        grades = "Hodnosti",
        storage = "Sklad",
        outfits = "Uniformy",
        logout = "Odhlásit se",
        menu = "Menu",
        finances = "Finance",
        balance = "Zůstatek",
        deposit = "Vložit",
        withdraw = "Vybrat",
        mostActiveEmployees = "Nejaktivnější zaměstnanci",
        grade = "Hodnost",
        lastweek = "Minulý týden",
        depositmoney = "Vložit peníze",
        withdrawmoney = "Vybrat peníze",
        amount = "Částka",
        hireEmployee = "Nabrat zaměstnance",
        fireemployee = "Propustit zaměstnance",
        selectperson = "Vyber osobu",
        hire = "Nabrat",
        edit = "Upravit",
        actions = "Akce",
        name = "Jméno",
        save = "Uložit",
        editemployee = "Upravit zaměstnance",
        cancel = "Zrušit",
        fire = "Propustit",
        wanttofire = "Opravdu chceš propustit",
        selectuser = "Vyber hráče",
        wanttobehired = "Chceš být najat do",
        helpmenucommand = "Otevřít menu šéfa",
        helpdutycommand = "Otevřít služební menu",
        goonduty = "Jít do služby",
        gooffduty = "Ukončit službu",
        openbossmenu = "Otevřít menu šéfa",
        opendutymenu = "Otevřít služební menu",
        online = "Online",
        offline = "Offline",
        performance = "Výkon",
        status = "Stav",
        total = "Celkem",
        lastsevendays = "Posledních 7 dní",
        hours = "Hodiny",
        duty = "Služba",
        monday = "Pondělí",
        tuesday = "Úterý",
        wednesday = "Středa",
        thursday = "Čtvrtek",
        friday = "Pátek",
        saturday = "Sobota",
        sunday = "Neděle",
        today = "Dnes",
        rank = "Pozice",
        salary = "Plat",
        delete = "Smazat",
        wanttodelete = "Opravdu chceš smazat",
        recruit = "Nabrat",
        lastonline = "Naposledy online",
        noinfo = "Žádné informace",
        givebonus = "Dát bonus",
        confirm = "Potvrdit",
        none = "Žádný",
        nogangaffiliation = "Bez gangu",
        unemployed = "nezaměstnaný",
        unemployedLabel = "Nezaměstnaný",
        nodata = "Žádná data",
        noinfoavailable = "Žádné informace k dispozici",
        bonusreceived = "Bonus přijat - ",
    },
}
