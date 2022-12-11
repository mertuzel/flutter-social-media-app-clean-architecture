import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:friend_zone/src/app/constants/constants.dart';
import 'package:friend_zone/src/data/utils/string_utils.dart';
import 'package:friend_zone/src/domain/entities/post.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

class KPost extends StatelessWidget {
  final Post post;
  final Function(Post post) changePostLike;
  final Function(Post post) toggleFavoriteState;
  final Function(BuildContext context, Post post) navigateToComments;
  final int index;
  final bool isSeen = false;
  final bool showAnimation;

  KPost({
    required this.index,
    required this.post,
    required this.changePostLike,
    required this.toggleFavoriteState,
    required this.navigateToComments,
    required this.showAnimation,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isCurrentUserPost =
        post.publisherId == FirebaseAuth.instance.currentUser!.uid;

    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 17, right: 17),
          margin: EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35),
            color: kWhite,
            boxShadow: kBoxShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 1),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35),
                            border: Border.all(color: kBlack.withOpacity(0.04)),
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: post.publisherLogoUrl.isEmpty
                                  ? Image.asset(
                                      isCurrentUserPost
                                          ? 'assets/icons/png/current_user.png'
                                          : 'assets/icons/png/default_user.png',
                                      height: 35,
                                      width: 35,
                                    )
                                  : CachedNetworkImage(
                                      imageUrl: post.publisherLogoUrl,
                                      height: 35,
                                      width: 35,
                                      fit: BoxFit.cover,
                                      placeholder: (a, b) {
                                        return ShimmheredPublisher();
                                      },
                                    )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Text(post.publisher,
                              style: k14w700AxiBlackUnderlinedText(
                                color: kBlack,
                                nullHeight: true,
                              )),
                        ),
                      ],
                    ),
                    Text(
                      StringUtils.getPublishDateShort(post.publishedOn),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: kBlack.withOpacity(0.26),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1,
                color: Color(0xFFC4C4C4).withOpacity(0.1),
              ),
              Container(
                margin: EdgeInsets.only(top: 16, bottom: 17),
                height: MediaQuery.of(context).size.width - 34,
                width: MediaQuery.of(context).size.width - 34,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  boxShadow: [
                    BoxShadow(
                      color: kBlack.withOpacity(0.2),
                      spreadRadius: 0,
                      blurRadius: 14,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Stack(
                    children: [
                      GestureDetector(
                        onDoubleTap: () => changePostLike(post),
                        child: Container(
                            child: CachedNetworkImage(
                          imageUrl: post.imageUrl,
                          fit: BoxFit.fill,
                          width: MediaQuery.of(context).size.width - 34,
                          height: MediaQuery.of(context).size.width - 34,
                          placeholder: (a, b) {
                            return ImageShimmer();
                          },
                        )),
                      ),
                      showAnimation
                          ? Container(
                              height: MediaQuery.of(context).size.width - 34,
                              width: MediaQuery.of(context).size.width - 34,
                              child: Center(
                                child: Container(
                                  width: 250,
                                  height: 250,
                                  child: Lottie.asset(
                                      'assets/animations/post_like_animation.json'),
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () => changePostLike(post),
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 3),
                                child: SvgPicture.asset(
                                  post.isLiked
                                      ? 'assets/icons/svg/heart_filled.svg'
                                      : 'assets/icons/svg/heart.svg',
                                  color: kPrimary,
                                ),
                              ),
                              SizedBox(width: 3),
                              Text(
                                post.numberOfLikes.toString(),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () => navigateToComments(context, post),
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 19),
                                child: SvgPicture.asset(
                                  'assets/icons/svg/comment.svg',
                                  color: kPrimary,
                                ),
                              ),
                              SizedBox(width: 3),
                              Text(
                                post.numberOfComments.toString(),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => toggleFavoriteState(post),
                      child: Container(
                        margin: EdgeInsets.only(right: 3),
                        child: SvgPicture.asset(
                          post.isFavorited
                              ? 'assets/icons/svg/star_filled.svg'
                              : 'assets/icons/svg/star.svg',
                          color: kPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 1,
                ),
                child: Text.rich(
                  TextSpan(
                    text: post.publisher + '  ',
                    style: TextStyle(
                      color: kBlack,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                    children: [
                      TextSpan(
                        text: post.description,
                        style: TextStyle(
                          color: kBlack,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 25),
            ],
          ),
        ),
      ],
    );
  }
}

class ShimmeredPost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: kWhite,
      child: Shimmer(
        child: Container(
          width: size.width,
          padding: EdgeInsets.only(bottom: 5, left: 17, right: 17),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: kGrey,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: kBlack.withOpacity(0.04)),
                          ),
                        ),
                        Container(
                          width: 40,
                          height: 15,
                          margin: EdgeInsets.only(left: 3),
                          decoration: BoxDecoration(
                            color: kGrey,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: kBlack.withOpacity(0.04)),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 30,
                      height: 15,
                      decoration: BoxDecoration(
                        color: kGrey,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: kBlack.withOpacity(0.04)),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: size.width - 34,
                height: size.width - 34,
                decoration: BoxDecoration(
                  color: kGrey,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: kBlack.withOpacity(0.04)),
                ),
              ),
              SizedBox(height: 18),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 12,
                    decoration: BoxDecoration(
                      color: kGrey,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: kBlack.withOpacity(0.04)),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: 40,
                    height: 12,
                    decoration: BoxDecoration(
                      color: kGrey,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: kBlack.withOpacity(0.04)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
        gradient: kLinearGradient,
      ),
    );
  }
}

class ImageShimmer extends StatelessWidget {
  const ImageShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Shimmer(
        child: Container(
          width: size.width - 34,
          height: size.width - 34,
          decoration: BoxDecoration(
            color: kGrey,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: kBlack.withOpacity(0.04)),
          ),
        ),
        gradient: kLinearGradient);
  }
}

class ShimmheredPublisher extends StatelessWidget {
  const ShimmheredPublisher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Shimmer(
        child: Container(
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            color: kGrey,
            shape: BoxShape.circle,
            border: Border.all(color: kBlack.withOpacity(0.04)),
          ),
        ),
        gradient: kLinearGradient);
  }
}
