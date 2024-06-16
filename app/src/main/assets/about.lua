require "import"
import "mod"
import "color"

layout2={
  LinearLayout;
  layout_height="fill";
  layout_width="fill";
  orientation="vertical";
  {
    LinearLayout;
    layout_height="56dp";
    layout_width="fill";
    id="mainActionBar";
    elevation=4;
    gravity="left|center";
    paddingLeft="12dp";
    {
      ImageView;
      id="back";
      src=ICON_BACK;
      layout_width="24dp";
      layout_height="24dp";
      layout_gravity="center";
      layout_marginRight="12dp";
    };
    {
      TextView;
      text="关于";
      textSize="20sp";
      id="mainTitle";
      onClick=function(view)
        c=c-1
        if c==0 then
          if activity.getSharedData("devmode")~=true then
            activity.setSharedData("devmode",true)
            print("开发者模式已开启")
           else
            activity.setSharedData("devmode",false)
            print("开发者模式已关闭")
          end
          c=5
        end
      end
    };
  };
  {
    ScrollView;
    layout_width="fill";
    layout_height="fill";
    VerticalScrollBarEnabled=false;
    id="mainBackground";
    {
      LinearLayout;
      orientation="vertical";
      id="NoteBackground1";
      layout_width="fill";
      layout_height="fill";
    };
  };
}

c=5
设置视图(layout2)

水波纹(back)

mainActionBar.setBackgroundColor(COLOR_MAIN)
mainBackground.setBackgroundColor(COLOR_MAIN_BACKGROUND)
mainTitle.setTextColor(COLOR_ON_MAIN)
mainTitle.getPaint().setFakeBoldText(true)
设置字体(mainTitle)
aboutList={
  LinearLayout;
  id="NoteBackground2";
  Orientation="vertical";
  layout_width="fill";
  layout_height="fill";
  {
    CardView;
    id="cardBackground";
    layout_width="fill";
    layout_height="wrap";
    layout_margin="12dp";
    radius="8dp";
    elevation="0";
    {
      LinearLayout;
      layout_width="fill";
      layout_height="wrap";
      padding="8dp";
      {
        LinearLayout;
        layout_width="fill";
        layout_height="wrap";
        layout_weight=1;
        Orientation="vertical";
        gravity="center";
        {
          ImageView;
          id="appIcon";
          layout_width="96dp";
          layout_height="96dp";
        };
        {
          TextView;
          id="appNameText";
          layout_width="wrap";
          layout_height="wrap";
          textSize="16sp";
        };
        {
          TextView;
          id="appVerText";
          layout_width="wrap";
          layout_height="wrap";
          textSize="14sp";
        };
        {
          CardView;
          id="checkUpdate";
          layout_width="wrap";
          layout_height="wrap";
          layout_margin="8dp";
          radius="16dp";
          elevation="4";
          {
            TextView;
            id="checkUpdateText";
            paddingLeft="16dp";
            paddingRight="16dp";
            paddingTop="8dp";
            paddingBottom="8dp";
            textSize="14sp";
            text="获取更新";
          };
        };
      };
      {
        LinearLayout;
        layout_width="fill";
        layout_height="fill";
        layout_weight=1;
        Orientation="vertical";
        gravity="center";
        {
          CircleImageView;
          layout_width="96dp";
          layout_height="96dp";
          src="icon/author.jpg"
        };
        {
          TextView;
          id="authorNameText";
          layout_width="wrap";
          layout_height="wrap";
          textSize="16sp";
          text="@一個冬瓜";
        };
        {
          TextView;
          id="authorText";
          layout_width="wrap";
          layout_height="wrap";
          textSize="14sp";
          text="作者";
        };
        {
          CardView;
          id="contactAuthor";
          layout_width="wrap";
          layout_height="wrap";
          layout_margin="8dp";
          radius="16dp";
          elevation="4";
          {
            TextView;
            id="contactAuthorText";
            paddingLeft="16dp";
            paddingRight="16dp";
            paddingTop="8dp";
            paddingBottom="8dp";
            textSize="14sp";
            text="联系作者";
          }
        }
      }
    }
  }
}
NoteBackground1.addView(loadlayout(aboutList))
cardBackground.setBackgroundColor(COLOR_CARD_BACKGROUND)
水波纹(checkUpdateText)

appIcon.setImageResource(R.drawable.ic_launcher)
appNameText.setText(appName)
appVerText.setText(ver.."("..tostring(verc)..")")
设置字体(appNameText)
设置字体(appVerText)

checkUpdate.setBackgroundColor(COLOR_CARD_BACKGROUND)
checkUpdateText.setTextColor(COLOR_ON_BACKGROUND)
设置字体(checkUpdateText)

设置字体(authorNameText)
设置字体(authorText)

水波纹(contactAuthorText)
contactAuthor.setBackgroundColor(COLOR_CARD_BACKGROUND)
contactAuthorText.setTextColor(COLOR_ON_BACKGROUND)
设置字体(contactAuthorText)

contactAuthorText.onClick=function()
  AlertDialog.Builder(this)
  .setMessage("是否允许应用启动 酷安")
  .setPositiveButton("允许", {onClick=function(v)
      local url="coolmarket://u/4239876"
      activity.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)))
    end})
  .setNegativeButton("取消",nil)
  .show()
end

trynum=0
function getUpdate()
  if File(patht.."update.json").isFile() then
    lastCheck=cjson.decode(读取文件(patht.."update.json"))
    local logs=lastCheck.logs:gsub("\\r\\n","\n")
    checkUpdateText.onClick=function()
      AlertDialog.Builder(this)
      .setTitle("更新日志")
      .setMessage(logs)
      .setPositiveButton("国内云盘("..lastCheck.pwd1..")",{onClick=function(v)
          activity.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(lastCheck.link1)))
        end})
      .setNegativeButton("Github直链",{onClick=function(v)
          activity.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(lastCheck.link2)))
        end})
      .setNeutralButton("取消",nil)
      .show()
    end
    if tonumber(lastCheck.versionCode)==verc then
      checkUpdateText.setText("已是最新")
      checkUpdateText.setTextColor(0xFFAAAAAA)
     else
      if tonumber(lastCheck.versionCode)>verc then
        checkUpdateText.setText("更新("..lastCheck.version..")")
        checkUpdateText.setTextColor(0xFFCC0000)
       elseif tonumber(lastCheck.versionCode)<verc then
        if trynum==0 then
          update(true)
          task(2000,function()getUpdate()end)
          trynum=trynum+1
         else
          checkUpdateText.setText("非正式版本!")
          checkUpdateText.setTextColor(0xFFCC0000)
        end
      end
    end
   else
    checkUpdateText.onClick=function()
      if activity.getSystemService(Context.CONNECTIVITY_SERVICE).getActiveNetworkInfo() then
        checkUpdateText.setText("获取更新中…")
        checkUpdateText.setTextColor(0xFFAAAAAA)
        update()
        task(2000,function()getUpdate()end)
       else
        checkUpdateText.setText("无网络连接")
        checkUpdateText.setTextColor(0xFFCC0000)
      end
    end
  end
end
getUpdate()

item={
  LinearLayout;
  id="NoteBackground3";
  layout_height="wrap";
  layout_width="fill";
  {
    LinearLayout;
    id="NoteBackground4";
    layout_height="fill";
    layout_width="fill";
    {
      LinearLayout;
      id="NoteBackground5";
      layout_width="fill";
      padding="16dp";
      layout_height="fill";
      Orientation="vertical";
      {
        TextView;
        maxLines="2";
        id="NoteTitle";
        text="标题";
        textSize="16sp";
      };
      {
        TextView;
        maxLines="3";
        id="NoteText";
        text="内容";
        textSize="14sp";
      };
    };
  };
};

NoteBackground2.addView(loadlayout(item))
NoteBackground3.setBackgroundColor(COLOR_MAIN_BACKGROUND)
NoteTitle.setTextColor(COLOR_ON_BACKGROUND)
NoteTitle.setText("Tips")
NoteText.setText("获得实用小技巧")
设置字体(NoteTitle)
设置字体(NoteText)
id=NoteBackground5
水波纹(id)
id.onClick=function(view)
  activity.newActivity("help")
end

NoteBackground2.addView(loadlayout(item))
NoteBackground3.setBackgroundColor(COLOR_MAIN_BACKGROUND)
NoteTitle.setTextColor(COLOR_ON_BACKGROUND)
NoteTitle.setText("清除缓存")
NoteText.setText("清除使用过程中产生的缓存文件")
设置字体(NoteTitle)
设置字体(NoteText)
id=NoteBackground5
水波纹(id)
id.onClick=function(view)
  os.execute("rm -rf "..patht.."*")
  os.execute("rm -rf "..dir.."__send_data_*")
  print("清除成功")
end

NoteBackground2.addView(loadlayout(item))
NoteBackground3.setBackgroundColor(COLOR_MAIN_BACKGROUND)
NoteTitle.setTextColor(COLOR_ON_BACKGROUND)
NoteTitle.setText("开源许可")
NoteText.setText("查看软件所使用的开源库")
设置字体(NoteTitle)
设置字体(NoteText)
id=NoteBackground5
水波纹(id)
id.onClick=function(view)
  activity.newActivity("license")
end

--[[checkboxItem={
  LinearLayout;
  id="NoteBackground3";
  layout_height="wrap";
  layout_width="fill";
  {
    FrameLayout;
    id="NoteBackground4";
    layout_height="fill";
    layout_width="fill";
    {
      LinearLayout;
      id="NoteBackground5";
      layout_width="wrap";
      padding="16dp";
      layout_height="fill";
      Orientation="vertical";
      {
        TextView;
        maxLines="2";
        id="NoteTitle";
        textSize="16sp";
      };
    };
    {
      LinearLayout;
      layout_height="fill";
      layout_width="wrap";
      layout_gravity="center|right";
      {
        CheckBox;
        layout_height="fill";
        gravity="center";
        paddingRight="16dp";
        id="CBox";
        clickable=false
      };
    };
  };
};
NoteBackground2.addView(loadlayout(checkboxItem))
NoteBackground3.setBackgroundColor(COLOR_MAIN_BACKGROUND)
NoteTitle.setTextColor(COLOR_ON_BACKGROUND)
NoteTitle.setText("停止软件获取IP信息")
设置字体(NoteTitle)
设置字体(NoteText)
id=NoteBackground4
水波纹(id)
cb1=CBox
if activity.getSharedData("stopGettingIP") == nil then
  cb1.setChecked(false)
 else
  cb1.setChecked(activity.getSharedData("stopGettingIP"))
end
id.onClick=function(view)
  if cb1.isChecked() then
    cb1.setChecked(false)
    activity.setSharedData("stopGettingIP", false)
   else
    cb1.setChecked(true)
    activity.setSharedData("stopGettingIP", true)
    os.remove(pathc.."LastIPInfo.json")
  end
end]]

back.onClick=function(view)
  activity.finish()
end

