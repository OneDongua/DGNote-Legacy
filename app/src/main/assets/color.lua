require "import"
import "mod"

function isNightMode()
  local configuration = activity.getResources().getConfiguration()
  return configuration.uiMode+1 == configuration.UI_MODE_NIGHT_YES
  or configuration.uiMode-1 == configuration.UI_MODE_NIGHT_YES
  or configuration.uiMode == configuration.UI_MODE_NIGHT_YES
end

function whiteIcon()
  ICON_MENU="icon/more_white.png"
  ICON_ADD="icon/add_white.png"
  ICON_BACK="icon/back_white.png"
  ICON_DELETE="icon/delete_white.png"
  ICON_RESTORE="icon/restore_white.png"
  ICON_UNDO="icon/undo_white.png"
  ICON_REDO="icon/redo_white.png"
  ICON_CHECK="icon/check_white.png"
  ICON_REFRESH="icon/refresh_white.png"
  ICON_SELECT_ALL="icon/select_all_white.png"
  ICON_MOVE_FILE="icon/move_file_white.png"
  ICON_DARK_MODE="icon/dark_mode_white.png"
  ICON_LIGHT_MODE="icon/light_mode_white.png"
end

function blackIcon()
  ICON_MENU="icon/more_black.png"
  ICON_ADD="icon/add_black.png"
  ICON_BACK="icon/back_black.png"
  ICON_DELETE="icon/delete_black.png"
  ICON_RESTORE="icon/restore_black.png"
  ICON_UNDO="icon/undo_black.png"
  ICON_REDO="icon/redo_black.png"
  ICON_CHECK="icon/check_black.png"
  ICON_REFRESH="icon/refresh_black.png"
  ICON_SELECT_ALL="icon/select_all_black.png"
  ICON_MOVE_FILE="icon/move_file_black.png"
  ICON_DARK_MODE="icon/dark_mode_black.png"
  ICON_LIGHT_MODE="icon/light_mode_black.png"
end

function darkModeIcon()
  ICON_VISIBILITY_ON="icon/visibility_white.png"
  ICON_VISIBILITY_OFF="icon/visibility_off_white.png"
  ICON_INFO="icon/info_white.png"

  ICON_MD_BOLD="icon/markdown/bold_white.png"
  ICON_MD_CHECK_BOX="icon/markdown/check_box_white.png"
  ICON_MD_CHECKED_BOX="icon/markdown/checked_box_white.png"
  ICON_MD_CODE="icon/markdown/code_white.png"
  ICON_MD_ITALIC="icon/markdown/italic_white.png"
  ICON_MD_LIST_BULLETED="icon/markdown/list_bulleted_white.png"
  ICON_MD_LIST_NUMBERED="icon/markdown/list_numbered_white.png"
  ICON_MD_QUOTE="icon/markdown/quote_white.png"
  ICON_MD_STRIKETHROUGH="icon/markdown/strikethrough_white.png"
  ICON_MD_UNDERLINED="icon/markdown/underlined_white.png"
  ICON_MD_TASK="icon/markdown/task_white.png"
  ICON_MD_IMAGE="icon/markdown/image_white.png"
  ICON_MD_HRADLINE="icon/markdown/headline_white.png"
end

function brightModeIcon()
  ICON_VISIBILITY_ON="icon/visibility_black.png"
  ICON_VISIBILITY_OFF="icon/visibility_off_black.png"
  ICON_INFO="icon/info_black.png"

  ICON_MD_BOLD="icon/markdown/bold_black.png"
  ICON_MD_CHECK_BOX="icon/markdown/check_box_black.png"
  ICON_MD_CHECKED_BOX="icon/markdown/checked_box_black.png"
  ICON_MD_CODE="icon/markdown/code_black.png"
  ICON_MD_ITALIC="icon/markdown/italic_black.png"
  ICON_MD_LIST_BULLETED="icon/markdown/list_bulleted_black.png"
  ICON_MD_LIST_NUMBERED="icon/markdown/list_numbered_black.png"
  ICON_MD_QUOTE="icon/markdown/quote_black.png"
  ICON_MD_STRIKETHROUGH="icon/markdown/strikethrough_black.png"
  ICON_MD_UNDERLINED="icon/markdown/underlined_black.png"
  ICON_MD_TASK="icon/markdown/task_black.png"
  ICON_MD_IMAGE="icon/markdown/image_black.png"
  ICON_MD_HRADLINE="icon/markdown/headline_black.png"
end

function whiteStatusText()
  if Build.VERSION.SDK_INT >= 23 then
    activity.getWindow().getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_VISIBLE); --白字
  end
end

function blackStatusText()
  if Build.VERSION.SDK_INT >= 23 then
    activity.getWindow().getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR); --黑字
  end
end

function initializeColor() --函数便于调用刷新
  if sharedData.color == "自定义" and File(pathc.."ThemeConfig.json").isFile() then
    local conf = cjson.decode(读取文件(pathc.."ThemeConfig.json"))
    if isNightMode() then
      COLOR_MAIN_RIPPLE=0x25FFFFFF
      COLOR_MAIN=math.floor(conf.dark.COLOR_MAIN or 0xFF000000)
      COLOR_ACCENT=math.floor(conf.dark.COLOR_ACCENT or 0xFF009688)
      COLOR_CARD_SELECTED=math.floor(conf.dark.COLOR_ACCENT or 0xFF009688)-0xB7000000
      COLOR_MAIN_BACKGROUND=math.floor(conf.dark.COLOR_MAIN_BACKGROUND or 0xFF161616)
      COLOR_CARD_BACKGROUND=math.floor(conf.dark.COLOR_CARD_BACKGROUND or 0xFF202020)
      COLOR_ON_BACKGROUND=math.floor(conf.dark.COLOR_ON_BACKGROUND or 0xFFFFFFFF)
      COLOR_ON_BACKGROUND_SEC=math.floor(conf.dark.COLOR_ON_BACKGROUND_SEC or 0xFFFFFFFF)
      if conf.dark.PREF_UIMODE_MAIN == "white" then
        COLOR_ON_MAIN=0xFFFFFFFF
        whiteIcon()
        whiteStatusText()
       elseif conf.dark.PREF_UIMODE_MAIN == "black" then
        COLOR_ON_MAIN=0xFF000000
        blackIcon()
        blackStatusText()
      end
      darkModeIcon()
      activity.setTheme(android.R.style.Theme_Material_NoActionBar)
     else
      COLOR_MAIN_RIPPLE=0x15000000
      COLOR_MAIN=math.floor(conf.light.COLOR_MAIN or 0xFF009688)
      COLOR_ACCENT=math.floor(conf.light.COLOR_ACCENT or 0xFF009688)
      COLOR_CARD_SELECTED=math.floor(conf.light.COLOR_ACCENT or 0xFF009688)-0xB7000000
      COLOR_MAIN_BACKGROUND=math.floor(conf.light.COLOR_MAIN_BACKGROUND or 0xFFF5F5F5)
      COLOR_CARD_BACKGROUND=math.floor(conf.light.COLOR_CARD_BACKGROUND or 0xFFFFFFFF)
      COLOR_ON_BACKGROUND=math.floor(conf.light.COLOR_ON_BACKGROUND or 0xFF000000)
      COLOR_ON_BACKGROUND_SEC=math.floor(conf.light.COLOR_ON_BACKGROUND_SEC or 0xFF000000)
      if conf.light.PREF_UIMODE_MAIN == "white" then
        COLOR_ON_MAIN=0xFFFFFFFF
        whiteIcon()
        whiteStatusText()
       elseif conf.light.PREF_UIMODE_MAIN == "black" then
        COLOR_ON_MAIN=0xFF000000
        blackIcon()
        blackStatusText()
      end
      brightModeIcon()
      activity.setTheme(android.R.style.Theme_Material_Light_NoActionBar)
    end

   else
    local color = sharedData.color
    switch color
     case "鸭绿" then
      COLOR_MAIN_RIPPLE=0x15000000
      COLOR_ON_MAIN=0xFFFFFFFF
      COLOR_MAIN=0xFF009688
      COLOR_ACCENT=0xFF009688
      COLOR_CARD_SELECTED=0x48009688
      whiteIcon()
      whiteStatusText()
     case "蓝色" then
      COLOR_MAIN_RIPPLE=0x15000000
      COLOR_ON_MAIN=0xFFFFFFFF
      COLOR_MAIN=0xFF2196F3
      COLOR_ACCENT=0xFF2196F3
      COLOR_CARD_SELECTED=0x482196F3
      whiteIcon()
      whiteStatusText()
     case "粉色" then
      COLOR_MAIN_RIPPLE=0x15000000
      COLOR_ON_MAIN=0xFFFFFFFF
      COLOR_MAIN=0xFFFA7298
      COLOR_ACCENT=0xFFFA7298
      COLOR_CARD_SELECTED=0x48FA7298
      whiteIcon()
      whiteStatusText()
     case "靛蓝" then
      COLOR_MAIN_RIPPLE=0x15000000
      COLOR_ON_MAIN=0xFFFFFFFF
      COLOR_MAIN=0xFF3F51B5
      COLOR_ACCENT=0xFF3F51B5
      COLOR_CARD_SELECTED=0x483F51B5
      whiteIcon()
      whiteStatusText()
     case "绿色" then
      COLOR_MAIN_RIPPLE=0x15000000
      COLOR_ON_MAIN=0xFFFFFFFF
      COLOR_MAIN=0xFF109D58
      COLOR_ACCENT=0xFF109D58
      COLOR_CARD_SELECTED=0x48109D58
      whiteIcon()
      whiteStatusText()
     case "灰色" then
      COLOR_MAIN_RIPPLE=0x15000000
      COLOR_ON_MAIN=0xFFFFFFFF
      COLOR_MAIN=0xFF616161
      COLOR_ACCENT=0xFF616161
      COLOR_CARD_SELECTED=0x48616161
      whiteIcon()
      whiteStatusText()
     case "蓝灰" then
      COLOR_MAIN_RIPPLE=0x15000000
      COLOR_ON_MAIN=0xFFFFFFFF
      COLOR_MAIN=0xFF607D8B
      COLOR_ACCENT=0xFF607D8B
      COLOR_CARD_SELECTED=0x48607D8B
      whiteIcon()
      whiteStatusText()
     case "纯白" then
      COLOR_MAIN_RIPPLE=0x15000000
      COLOR_ON_MAIN=0xFF000000
      COLOR_MAIN=0xFFFFFFFF
      COLOR_ACCENT=0xFF000000
      COLOR_CARD_SELECTED=0x48000000
      blackIcon()
      blackStatusText()
      if isNightMode() then
        COLOR_MAIN_RIPPLE=0x15FFFFFF
        COLOR_ACCENT=0xFFFFFFFF
        COLOR_CARD_SELECTED=0x48FFFFFF
      end
     case "纯黑" then
      COLOR_MAIN_RIPPLE=0x25000000
      COLOR_ON_MAIN=0xFFFFFFFF
      COLOR_MAIN=0xFF000000
      COLOR_ACCENT=0xFF000000
      COLOR_CARD_SELECTED=0x48000000
      whiteIcon()
      whiteStatusText()
      if isNightMode() then
        COLOR_MAIN_RIPPLE=0x25FFFFFF
        COLOR_ACCENT=0xFFFFFFFF
        COLOR_CARD_SELECTED=0x48FFFFFF
      end
     default --默认
      COLOR_MAIN_RIPPLE=0x15000000
      COLOR_ON_MAIN=0xFFFFFFFF
      COLOR_MAIN=0xFF009688
      COLOR_ACCENT=0xFF009688
      COLOR_CARD_SELECTED=0x48009688
      whiteIcon()
      whiteStatusText()
    end
    --与不同主题无关的颜色设置
    if isNightMode() then
      whiteIcon()
      whiteStatusText()
      COLOR_MAIN_RIPPLE=0x25FFFFFF
      --COLOR_MAIN_BACKGROUND=0xFF161616
      COLOR_MAIN_BACKGROUND=0xFF161616
      --COLOR_CARD_BACKGROUND=0xFF000000
      COLOR_CARD_BACKGROUND=0xFF202020
      COLOR_ON_BACKGROUND=0xFFFFFFFF
      COLOR_ON_BACKGROUND_SEC=0xFFFFFFFF
      COLOR_MAIN=0xFF000000
      COLOR_ON_MAIN=0xFFFFFFFF
      darkModeIcon()
      --activity.setTheme(android.R.style.Theme_DeviceDefault_NoActionBar)
      activity.setTheme(android.R.style.Theme_Material_NoActionBar)
     else
      COLOR_MAIN_BACKGROUND=0xFFF5F5F5
      COLOR_CARD_BACKGROUND=0xFFFFFFFF
      COLOR_ON_BACKGROUND=0xFF000000
      COLOR_ON_BACKGROUND_SEC=0xFF000000
      brightModeIcon()
      --activity.setTheme(android.R.style.Theme_DeviceDefault_Light_NoActionBar)
      activity.setTheme(android.R.style.Theme_Material_Light_NoActionBar)
    end
  end
end
initializeColor()

activity.getWindow().setStatusBarColor(COLOR_MAIN)
