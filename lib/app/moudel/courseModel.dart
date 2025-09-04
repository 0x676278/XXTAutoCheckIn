class CourseDataWrapper {
  int? result;
  String? msg;
  List<Channel>? channelList;

  CourseDataWrapper({this.result, this.msg, this.channelList});

  factory CourseDataWrapper.fromJson(Map<String, dynamic> json) {
    return CourseDataWrapper(
      result: json['result'] as int?,
      msg: json['msg']?.toString(),
      channelList: (json['channelList'] as List<dynamic>?)
          ?.map((e) => Channel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Channel {
  int? cfid;
  int? norder;
  String? cataName;
  String? cataid;
  int? id;
  int? cpi;
  int? key;
  Content? content;
  int? topsign;

  Channel({
    this.cfid,
    this.norder,
    this.cataName,
    this.cataid,
    this.id,
    this.cpi,
    this.key,
    this.content,
    this.topsign,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      cfid: json['cfid'] as int?,
      norder: json['norder'] as int?,
      cataName: json['cataName']?.toString(),
      cataid: json['cataid']?.toString(),
      id: json['id'] as int?,
      cpi: json['cpi'] as int?,
      key: json['key'] as int?,
      content: json['content'] != null
          ? Content.fromJson(json['content'] as Map<String, dynamic>)
          : null,
      topsign: json['topsign'] as int?,
    );
  }
}

class Content {
  int? studentcount;
  String? chatid;
  int? isFiled;
  int? isthirdaq;
  bool? isstart;
  int? isretire;
  String? name;
  Course? course;
  int? roletype;
  int? id;
  int? state;
  int? cpi;
  String? bbsid;
  int? isSquare;

  Content({
    this.studentcount,
    this.chatid,
    this.isFiled,
    this.isthirdaq,
    this.isstart,
    this.isretire,
    this.name,
    this.course,
    this.roletype,
    this.id,
    this.state,
    this.cpi,
    this.bbsid,
    this.isSquare,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      studentcount: json['studentcount'] as int?,
      chatid: json['chatid']?.toString(),
      isFiled: json['isFiled'] as int?,
      isthirdaq: json['isthirdaq'] as int?,
      isstart: json['isstart'] as bool?,
      isretire: json['isretire'] as int?,
      name: json['name']?.toString(),
      course: json['course'] != null
          ? Course.fromJson(json['course'] as Map<String, dynamic>)
          : null,
      roletype: json['roletype'] as int?,
      id: json['id'] as int?,
      state: json['state'] as int?,
      cpi: json['cpi'] as int?,
      bbsid: json['bbsid']?.toString(),
      isSquare: json['isSquare'] as int?,
    );
  }
}

class Course {
  List<CourseData>? data;

  Course({this.data});

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => CourseData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class CourseData {
  int? createtime;
  String? appInfo;
  int? defaultShowCatalog;
  int? sectionId;
  int? smartCourseState;
  int? appData;
  String? belongSchoolId;
  int? coursestate;
  String? teacherfactor;
  int? isCourseSquare;
  String? schools;
  String? courseSquareUrl;
  String? imageurl;
  String? name;
  int? id;

  CourseData({
    this.createtime,
    this.appInfo,
    this.defaultShowCatalog,
    this.sectionId,
    this.smartCourseState,
    this.appData,
    this.belongSchoolId,
    this.coursestate,
    this.teacherfactor,
    this.isCourseSquare,
    this.schools,
    this.courseSquareUrl,
    this.imageurl,
    this.name,
    this.id,
  });

  factory CourseData.fromJson(Map<String, dynamic> json) {
    return CourseData(
      createtime: json['createtime'] as int?,
      appInfo: json['appInfo']?.toString(),
      defaultShowCatalog: json['defaultShowCatalog'] as int?,
      sectionId: json['sectionId'] as int?,
      smartCourseState: json['smartCourseState'] as int?,
      appData: json['appData'] as int?,
      belongSchoolId: json['belongSchoolId']?.toString(),
      coursestate: json['coursestate'] as int?,
      teacherfactor: json['teacherfactor']?.toString(),
      isCourseSquare: json['isCourseSquare'] as int?,
      schools: json['schools']?.toString(),
      courseSquareUrl: json['courseSquareUrl']?.toString(),
      imageurl: json['imageurl']?.toString(),
      name: json['name']?.toString(),
      id: json['id'] as int?,
    );
  }
}
