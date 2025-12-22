
import 'package:ahzir/globals/ips.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ahzir/index.dart';

class CachedImageNetwork extends StatefulWidget {
  final double? width;
  final double? height;
  final double? loadingHeight;
  final String? image;
  final BoxFit? fit;
  final double? imageBorderRadius;
  final EdgeInsetsGeometry? errorImagePadding;


  const CachedImageNetwork({
    super.key,
    this.width,
    this.height,
    this.loadingHeight,
    this.fit,
    this.imageBorderRadius,
    required this.image,
    this.errorImagePadding,
  });

  @override
  State<CachedImageNetwork> createState() => _CachedImageNetworkState();
}

class _CachedImageNetworkState extends State<CachedImageNetwork> {
  @override
  Widget build(BuildContext context) {
    // print("errorImage ${widget.image}");
    return SizedBox(
      width: widget.width ?? MediaQuery.of(context).size.width,
      height: widget.height,
      child: widget.image != null && widget.image!.isNotEmpty
        ? LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints){
            final double width = constraints.maxWidth;
            final double height = constraints.maxHeight;
            final double aspectRatio = width / height;

            return ClipRRect(
              borderRadius: widget.imageBorderRadius != null ? BorderRadius.circular(widget.imageBorderRadius!) : BorderRadius.zero,
              child: CachedNetworkImage( // http://192.168.0.102:8080/api/assets/
                  // "${imageUrl}/${widget.image}",
                  imageUrl: "${widget.image}",
                  // "https://alrabiaa-backend.echovalley.net/api/assets/${widget.image}",
                  progressIndicatorBuilder: (context, child, loadingProgress){
                    return SizedBox(
                      height: widget.loadingHeight,
                      child: Center(
                          widthFactor: 25,
                          heightFactor: 25,
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        ),
                    );
                  },
                  errorWidget: (context, error, stackTrace) {  //add a default image
                    // print("errorImage88");
                    return Padding(
                      padding: widget.errorImagePadding ?? const EdgeInsets.all(0),
                      child: ClipRRect(
                        borderRadius: widget.imageBorderRadius != null ? BorderRadius.circular(widget.imageBorderRadius!) : BorderRadius.zero,
                        child: Image.asset(
                          '$staticImgUrl/logo/ihzar.png',
                          // fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                  // fit: widget.fit ?? (aspectRatio > 1.81 ? BoxFit.cover : BoxFit.fill),
                  fit: widget.fit,
                  width: widget.width ?? MediaQuery.of(context).size.width,
                  height: widget.height
              ),
            );
          }
        ) : Padding(
          padding: widget.errorImagePadding ?? const EdgeInsets.all(0),
          child: ClipRRect(
                borderRadius: widget.imageBorderRadius != null ? BorderRadius.circular(widget.imageBorderRadius!) : BorderRadius.zero,
                child: Image.asset('$staticImgUrl/logo/ihzar.png',)
      ),
        ), //add a default image
    );
  }
}

//this code is for sending cookie for the image
//
// class CachedImageNetwork extends StatefulWidget {
//   final double? width;
//   final double? height;
//   final String? image;
//   final BoxFit? fit;
//   final double? imageBorderRadius;
//   final EdgeInsetsGeometry? errorImagePadding;
//
//   const CachedImageNetwork({
//     Key? key,
//     this.width,
//     this.height,
//     this.fit,
//     this.imageBorderRadius,
//     required this.image,
//     this.errorImagePadding,
//   }) : super(key: key);
//
//   @override
//   State<CachedImageNetwork> createState() => _CachedImageNetworkState();
// }
//
// class _CachedImageNetworkState extends State<CachedImageNetwork> {
//   late Future<String?> token;
//
//   @override
//   void initState() {
//     super.initState();
//     token = getToken();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<String?>(
//       future: token,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(
//             child: CircularProgressIndicator(
//               color: primaryColor,
//             ),
//           );
//         } else if (snapshot.hasError) {
//           return _buildErrorImage();
//         } else {
//           return _buildCachedNetworkImage(snapshot.data);
//         }
//       },
//     );
//   }
//
//   Widget _buildCachedNetworkImage(String? token) {
//     return SizedBox(
//       width: widget.width ?? MediaQuery.of(context).size.width,
//       height: widget.height,
//       child: widget.image != null && widget.image!.isNotEmpty
//           ? LayoutBuilder(
//         builder: (BuildContext context, BoxConstraints constraints) {
//           final double width = constraints.maxWidth;
//           final double height = constraints.maxHeight;
//           final double aspectRatio = width / height;
//
//           return ClipRRect(
//             borderRadius: widget.imageBorderRadius != null
//                 ? BorderRadius.circular(widget.imageBorderRadius!)
//                 : BorderRadius.zero,
//             child: CachedNetworkImage(
//               imageUrl: widget.image!,
//               httpHeaders: {
//                 if (token != null) "Cookie": token,
//               },
//               progressIndicatorBuilder: (context, url, downloadProgress) =>
//                   Center(
//                     child: CircularProgressIndicator(
//                       value: downloadProgress.progress,
//                       color: primaryColor,
//                     ),
//                   ),
//               errorWidget: (context, url, error) => _buildErrorImage(),
//               fit: widget.fit ??
//                   (aspectRatio > 1.81 ? BoxFit.cover : BoxFit.fill),
//               width: widget.width ?? MediaQuery.of(context).size.width,
//               height: widget.height,
//             ),
//           );
//         },
//       )
//           : _buildErrorImage(),
//     );
//   }
//
//   Widget _buildErrorImage() {
//     return Padding(
//       padding: widget.errorImagePadding ?? const EdgeInsets.all(0),
//       child: ClipRRect(
//         borderRadius: widget.imageBorderRadius != null
//             ? BorderRadius.circular(widget.imageBorderRadius!)
//             : BorderRadius.zero,
//         child: Image.asset(
//           '$staticImgUrl/logo/logo.png',
//         ),
//       ),
//     );
//   }
//
//   Future<String?> getToken() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString("token");
//   }
// }
