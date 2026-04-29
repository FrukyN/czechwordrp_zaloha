const locale = {
  cd_dispatch_small_title: "Žádná tísňová volání",
  cd_dispatch_small_previous: "Předchozí",
  cd_dispatch_small_next: "Další",
  cd_dispatch_small_respond: "Reagovat",
  cd_dispatch_small_mode: "Klikněte pravým tlačítkem pro ukončení pohybového režimu.",

  cd_dispatch_main_show_refresh_bar: "Zobrazit",
  cd_dispatch_main_hide_refresh_bar: "Skrýt",
  cd_dispatch_main_refresh: "Obnovit blipy",
  cd_dispatch_main_close_refresh_bar: "Zavřít",
  cd_dispatch_main_refresh_last: "Naposledy obnoveno",

  cd_dispatch_main_units_responding: "jednotka/y reagují",

  cd_dispatch_unit_list: "Seznam jednotek",

  cd_dispatch_main_dropdown_respond: "Reagovat na upozornění",
  cd_dispatch_main_dropdown_remove_response: "Odstranit odpověď na upozornění",
  cd_dispatch_main_dropdown_remove_notification: "Odstranit toto upozornění",
  cd_dispatch_main_dropdown_remove_all: "Odstranit všechna upozornění",
  cd_dispatch_main_dropdown_assign_all: "Přiřadit všechny jednotky k volání",

  cd_dispatch_main_modal_title: "Nastavení dispatchu",
  cd_dispatch_main_modal_autodel: "Automaticky smazat po",
  cd_dispatch_main_modal_autodel_desc:"Čas potřebný k automatickému smazání upozornění. (V minutách, 1–60)",
  cd_dispatch_main_modal_set_callsign:"Aktualizovat volací znak",
  cd_dispatch_main_modal_set_callsign_help:"Tento volací znak bude viditelný pro všechny uživatele dispatchu",
  cd_dispatch_main_modal_assigned_vehicle:"Přiřazené vozidlo",
  cd_dispatch_main_modal_close: "Zavřít",
  cd_dispatch_main_modal_save: "Uložit změny",
  cd_dispatch_main_modal_vehicle_foot:" Pěšky",
  cd_dispatch_main_modal_vehicle_car:" Auto",
  cd_dispatch_main_modal_vehicle_motorcycle:" Motocykl",
  cd_dispatch_main_modal_vehicle_helicopter:" Helikoptéra",
  cd_dispatch_main_modal_vehicle_boat: " Loď",
  cd_dispatch_main_modal_sound_control: "Ovládání zvuku",
  cd_dispatch_main_modal_mute_sounds: " Ztišit zvuky",
  cd_dispatch_main_modal_mute_sounds_description: "Tato možnost ztlumí zvuky tísňového volání a upozornění",
  cd_dispatch_main_modal_enable_dispatcher: "Povolit režim dispečera?",
  cd_dispatch_main_modal_toggle_button:"Přepnout režim dispečera",
  cd_dispatch_main_modal_dispatcher_status: "Režim dispečera je nyní",
  cd_dispatch_main_modal_dispatcher_status_enabled: "zapnutý.",
  cd_dispatch_main_modal_dispatcher_status_disabled: "vypnutý.",

  cd_dispatch_unit_dropdown_gps: "Nastavit GPS lokaci",
  cd_dispatch_unit_join_radio:"Připojit se k rádiovému kanálu",
  cd_dispatch_unit_leave_radio:"Odejít z rádiového kanálu",

  cd_dispatch_toggle_voice_on: "Zapnout hlas",
  cd_dispatch_toggle_voice_off: "Vypnout hlas",
  cd_dispatch_revert_map: "Vrátit",

  cd_dispatch_notification_panel: "Panel upozornění",

  cd_dispatch_settings_status: "Stav",
  cd_dispatch_settings_status_help: "Vyberte svůj aktuální stav.",

  cd_dispatch_units_notification: "Žádné jednotky nereagují",

  cd_dispatch_tamper_message: "Upravili jste hodnoty?",
  cd_dispatch_callsign_message: "Volací znak musí mít méně než 16 znaků.",
};

let statusMessages = [
  {name:"Dostupný", color:"#539D1B"}, // Výchozí stav
  {name:"Nedostupný", color:"#F05B56"},
  {name:"Zpracovává", color:"#E46211"},
  {name:"Výcvik", color:"#009DE0"},
  {name:"V utajení", color:"#2E570F"},
]

moment.locale("en"); // The locale of the time on top of the small UI

// Possible locales v
// en,af,ar-dz,ar-kw,ar-ly,ar-ma,ar-sa,ar-tn,ar,az,be,bg,bm,bn-bd,bn,bo,br,bs,ca,cs,cv,cy,da,de-at,de-ch,de,dv,el,en-au,en-ca,en-gb,en-ie,en-il,en-in,en-nz,en-sg,eo,es-do,es-mx,es-us,es,et,eu,fa,fi,fil,fo,fr-ca,fr-ch,fr,fy,ga,gd,gl,gom-deva,gom-latn,gu,he,hi,hr,hu,hy-am,id,is,it-ch,it,ja,jv,ka,kk,km,kn,ko,ku,ky,lb,lo,lt,lv,me,mi,mk,ml,mn,mr,ms-my,ms,mt,my,nb,ne,nl-be,nl,nn,oc-lnc,pa-in,pl,pt-br,pt,ro,ru,sd,se,si,sk,sl,sq,sr-cyrl,sr,ss,sv,sw,ta,te,tet,tg,th,tk,tl-ph,tlh,tr,tzl,tzm-latn,tzm,ug-cn,uk,ur,uz-latn,uz,vi,x-pseudo,yo,zh-cn,zh-hk,zh-mo,zh-tw
