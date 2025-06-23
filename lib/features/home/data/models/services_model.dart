class ServicesModel {
  final int id;
  final String title;
  final String image;

  ServicesModel({
    required this.id,
    required this.title,
    required this.image,
  });

 static final List<ServicesModel> servisesList = [
  ServicesModel(id: 1,title: 'نظام العيادة', image: 'assets/images/svgs/hand.svg'),
  ServicesModel(id: 2, title: 'حجز موعد كشف', image: 'assets/images/svgs/calendar.svg'),
  ServicesModel(id: 3,title: 'المقالات', image: 'assets/images/svgs/document.svg'),
  ServicesModel(id: 4, title: 'الملف الشخصي', image: 'assets/images/svgs/child_head.svg'),
];
}


