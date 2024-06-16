require "import"
import "mod"
import "color"

layout2={
  LinearLayout;
  layout_height="fill";
  layout_width="fill";
  orientation="vertical";
  id="mainBackground";
  {
    FrameLayout;
    layout_width="fill";
    layout_height="56dp";
    elevation=4;
    id="mainActionBar";
    {
      LinearLayout;
      layout_height="fill";
      layout_gravity="center|left";
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
        gravity="center";
        id="mainTitle";
        text="开源许可";
        textSize="20sp";
        layout_height="fill";
      };
    };
  };
  {
    RecyclerView;
    layout_height="fill";
    layout_width="fill";
    id="mainRecycler";
  };
};

设置视图(layout2)

mainActionBar.setBackgroundColor(COLOR_MAIN)
mainTitle.setTextColor(COLOR_ON_MAIN)
mainTitle.getPaint().setFakeBoldText(true)
设置字体(mainTitle)
mainRecycler.setBackgroundColor(COLOR_MAIN_BACKGROUND)

data={
  {name = "名称", author = "作者", type = "许可类型", link = ""};
  {name = "Androlua+", author = "Nirenr", type = "The MIT License", link = "https://github.com/nirenr/AndroLua_pro"};
  {name = "commonmark-java", author = "Atlassian Pty Ltd", type = "BSD-2-Clause License", link = "https://github.com/commonmark/commonmark-java"};
  {name = "Sardine Android", author = "thegrizzlylabs", type = "Apache License 2.0", link = "https://github.com/thegrizzlylabs/sardine-android"};
  {name = "Android Support Library Custom View", author = "Google", type = "Apache License 2.0", link = "https://developer.android.com/jetpack/androidx"};
  {name = "Android Support RecyclerView", author = "Google", type = "Apache License 2.0", link = "https://developer.android.com/jetpack/androidx/releases/recyclerview"};
  {name = "CircleImageView", author = "Henning Dodenhof", type = "Apache License 2.0", link = "https://github.com/hdodenhof/CircleImageView"};
}

import "android.text.method.LinkMovementMethod"
import "android.text.SpannableStringBuilder"
import "android.text.style.URLSpan"
import "android.text.Spannable"
adapter=LuaCustRecyclerAdapter(AdapterCreator({
  getItemCount=function()
    return #data
  end,
  getItemViewType=function(position)
    return 0
  end,
  onCreateViewHolder=function(parent,viewType)
    local views={}
    local holder=LuaCustRecyclerHolder(loadlayout({
      LinearLayout;
      layout_height="wrap";
      layout_width="fill";
      padding="4dp";
      {
        TextView;
        id="name";
        layout_height="wrap";
        layout_width="fill";
        layout_weight=1;
        textSize="16sp";
        textColor=COLOR_ON_BACKGROUND_SEC;
        padding="4dp";
      };
      {
        TextView;
        id="author";
        layout_height="wrap";
        layout_width="fill";
        layout_weight=1;
        textSize="16sp";
        textColor=COLOR_ON_BACKGROUND_SEC;
        padding="4dp";
      };
      {
        TextView;
        id="type";
        layout_height="wrap";
        layout_width="fill";
        layout_weight=1;
        textSize="16sp";
        textColor=COLOR_ON_BACKGROUND_SEC;
        padding="4dp";
      };
    },views))
    holder.view.setTag(views)
    return holder
  end,
  onBindViewHolder=function(holder, position)
    local i = position+1
    local v = holder.view.getTag()

    v.name.setMovementMethod(LinkMovementMethod.getInstance())
    local spannableName = SpannableStringBuilder(data[i].name)
    if data[i].link ~= "" then
      spannableName.setSpan(URLSpan(data[i].link), 0, spannableName.length(), Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
    end
    v.name.setText(spannableName)

    v.author.setText(data[i].author)
    v.type.setText(data[i].type)
    v.name.onClick = function(v)
    end
  end
}))

mainRecycler.setAdapter(adapter)
mainRecycler.setLayoutManager(LinearLayoutManager(activity))

水波纹(back)
back.onClick=function(view)
  activity.finish()
end
