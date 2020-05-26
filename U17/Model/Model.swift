//
//  Model.swift
//  U17
//
//  Created by lyw on 2020/5/14.
//  Copyright © 2020 胡智钦. All rights reserved.
//

import HandyJSON

// 收藏漫画
struct favListModel: HandyJSON {
    var favList: [favModel]?
}

struct favModel: HandyJSON {
    var cate_id: String?
    var last_read_chapter_name: String?
    var status: String?
    var create_time: String?
    var user_id: String?
    var sort: Int = 0
    var cover: String?
    var fav_time: String?
    var name: String?
    var last_update_chapter_name: String?
    var flag: String?
    var author_id: String?
    var last_read_time: String?
    var comic_id: String?
    var last_update_chapter_id: String?
    var groups: String?
    var pass_chapter_num: Int = 0
    var last_read_chapter_id: String?
    var author_name: String?
    var first_letter: String?
    var last_read_image_id: String?
    var last_read_chapter_index: Int = 0
    var last_update_time: String?
    var series_status: Int = 0
}

// 我的书单
struct BookListModel: HandyJSON {
    var comic_num: String?
    var group_id: String?
    var create_time: String?
    var description: String?
    var cover: [String]?
    var name: String?
    var userCover: String?
}

// 阅读历史
struct ReadHistoryModel: HandyJSON {
    var last_read_chapter_name: String?
    var user_id: String?
    var create_time: String?
    var sort: Int = 0
    var is_view: String?
    var chapterType: String?
    var chapterBuyed: Int = 0
    var last_update_chapter_name: String?
    var chapterPrice: String?
    var author_id: String?
    var is_vip: String?
    var comic_id: String?
    var comic_name: String?
    var last_read_time: String?
    var last_update_chapter_id: String?
    var pass_chapter_num: String?
    var last_read_chapter_id: String?
    var author_name: String?
    var first_letter: String?
    var last_read_image_id: String?
    var last_read_page_index: Int = 0
    var comic_cover: String?
    var last_read_chapter_index: Int = 0
    var last_update_time: String?
    var cate_id: String?

}

struct TextItems: HandyJSON {

}

struct FloatItems: HandyJSON {
   var localInfoButton: Bool = false

}

struct Ext: HandyJSON {
   var key: String?
   var val: Int = 0

}

struct GalleryItems: HandyJSON {
   var content: String?
   var id: Int = 0
   var ext: [Ext]?
   var title: String?
   var topCover: String?
   var linkType: Int = 0
   var cover: String?

}

struct ItemModel: HandyJSON {
   var comicId: Int = 0
   var title: String?
   var cover: String?
   var subTitle: String?

   var linkType: Int = 0
   var id: Int = 0
   var content: String?
   var ext: [Ext]?

   var commentId: Int = 0
   var threadId: String?
   var objectType: String?
   var comment: String?
   var comicName: String?

}

struct ModuleInfo: HandyJSON {
   var argName: String?
   var argValue: Int = 0
   var title: String?
   var icon: String?
   var bgCover: String?

}

struct Modules: HandyJSON {
    var moduleInfo: ModuleInfo?
//    var items: AnyObject?
    var items: [[ItemModel]]?
    var moduleType: Int = 0
    var uiType: Int = 0
}

// 发现首页
struct HomeDatasModel: HandyJSON {
    var textItems: [TextItems]?
    var curTime: Int = 0
    var editTime: String?
    var floatItems: FloatItems?
    var galleryItems: [GalleryItems]?
    var defaultSearch: String?
    var modules: [Modules]?

}

// 漫画详情介绍页面
struct ComicDetailModel: HandyJSON {
       var otherWorks: [OtherWorks]?
       var comment: Comment?
       var comic: Comic?
       var tongRenCover: String?
       var chapter_list: [Chapter_list]?

}

struct OtherWorks: HandyJSON {
       var coverUrl: String?
       var passChapterNum: String?
       var comicId: String?
       var name: String?

}

struct ImageList: HandyJSON {

}

struct User: HandyJSON {
       var user_title: String?
       var nickname: String?
       var group_user: String?
       var is_author: Int = 0
       var grade: Int = 0
       var face: String?
       var vip_level: Int = 0
       var other_comic_author: Int = 0

}

struct CommentList: HandyJSON {
       var is_up: String?
       var total_reply: String?
       var content_filter: String?
       var praise_total: Int = 0
       var object_type: String?
       var imageList: [ImageList]?
       var create_time_str: String?
       var user_id: Int = 0
       var create_time: String?
       var gift_num: Int = 0
       var is_choice: String?
       var ticketNum: Int = 0
       var user: User?
       var comment_id: String?
       var thread_id: String?
       var comic_id: Int = 0
       var gift_img: String?
       var cate: String?
       var ticket_id: String?
       var is_delete: String?
       var content: String?
       var floor: String?

}

struct Comment: HandyJSON {
       var commentList: [CommentList]?
       var commentCount: Int = 0

}

struct Author: HandyJSON {
       var avatar: String?
       var name: String?
       var id: String?

}

struct Share: HandyJSON {
       var title: String?
       var content: String?
       var url: String?
       var cover: String?

}

struct ClassifyTags: HandyJSON {
       var name: String?
       var argName: String?
       var argVal: Int = 0

}

struct Comic: HandyJSON {
       var author: Author?
       var total_ticket: Int = 0
       var is_vip_buy: Bool = false
       var last_update_time: Int = 0
       var affiche: String?
       var wideCover: String?
       var is_vip: String?
       var total_tucao: Int = 0
       var accredit: Int = 0
       var description: String?
       var pass_chapter_num: Int = 0
       var is_vip_free: Bool = false
       var series_status: Int = 0
       var monthly_ticket: Int = 0
       var type: String?
       var ticket_desc: String?
       var thread_id: String?
       var month_ticket: String?
       var ori: String?
       var wideColor: String?
       var cover: String?
       var month_gift: Int = 0
       var theme_ids: [String]?
       var share: Share?
       var name: String?
       var favorite_total: Int = 0
       var comment_total: String?
       var vip_discount: CGFloat = 0.0
       var last_update_week: String?
       var comic_id: String?
       var status: String?
       var year_vip_discount: CGFloat = 0.0
       var is_free: Int = 0
       var is_auto_buy: Int = 0
       var week_more: String?
       var is_buy_action: Int = 0
       var classifyTags: [ClassifyTags]?
       var user_id: String?
       var gift_total: Int = 0
       var tagList: [String]?
       var short_description: String?
       var click_total: String?
       var cate_id: String?

}

struct ImHightArr: HandyJSON {
       var width: String?
       var height: String?

}

struct Chapter_list: HandyJSON {
       var image_total: String?
       var chapterIndex: Int = 0
       var buyed: String?
       var imHightArr: [ImHightArr]?
       var read_state: Int = 0
       var vip_images: String?
       var is_free: Int = 0
       var buy_price: String?
       var zip_high_webp: String?
       var size: String?
       var chapter_id: String?
       var is_download: Int = 0
       var publish_time: Int = 0
       var countImHightArr: Int = 0
       var is_view: Int = 0
       var name: String?
       var crop_zip_size: String?

}

// 所有章节
struct ChapterModel: HandyJSON {
       var image_total: String?
       var release_time: String?
       var is_view: Int = 0
       var is_new: Int = 0
       var vip_images: String?
       var publish_time: Int = 0
       var smallPlaceCover: String?
       var name: String?
       var chapterIndex: Int = 0
       var type: String?
       var size: String?
       var has_locked_image: Bool = false
       var is_free: Int = 0
       var is_download: Int = 0
       var crop_zip_size: String?
       var buy_price: String?
       var zip_high_webp: String?
       var read_state: Int = 0
       var buyed: String?
       var chapter_id: String?
       var countImHightArr: Int = 0
}

struct ChapterListModels: HandyJSON {
       var chapter_list: [ChapterModel]?
}

// 阅读漫画
struct Images: HandyJSON {
       var img05: String?
       var id: String?
       var img50: String?
       var sort: String?
       var width: String?
       var height: String?

}

struct Image_list: HandyJSON {
       var location: String?
       var height: String?
       var images: [Images]?
       var image_id: String?
       var width: String?
       var img05: String?
       var webp: String?
       var total_tucao: String?
       var type: String?
       var img50: String?

}

struct ReadComicModel: HandyJSON {
       var status: Int = 0
       var image_list: [Image_list]?
       var chapter_id: String?
       var type: String?
}


extension Array: HandyJSON {}

struct ReturnData<T: HandyJSON>: HandyJSON {
    var message:String?
    var returnData: T?
    var stateCode: Int = 0
}

struct ResponseData<T: HandyJSON>: HandyJSON {
    var code: Int = 0
    var data: ReturnData<T>?
}
