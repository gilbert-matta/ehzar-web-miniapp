import 'dart:convert';
import 'package:ahzir/functions/utils.dart';
import 'package:ahzir/index.dart';
import 'package:ahzir/models/model/chat_model.dart';
import 'package:ahzir/models/model/user_model.dart';
import 'package:ahzir/screens/next_screens.dart';
import 'package:ahzir/widgets/app_bar_widget.dart';
import 'package:ahzir/widgets/chat/chat_date_header.dart';
import 'package:ahzir/widgets/chat/group_name_logo.dart';
import 'package:ahzir/widgets/chat/user_receive_widget.dart';
import 'package:ahzir/widgets/chat/user_sender_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;
import 'group_chat_details.dart';

class ChatPage extends StatefulWidget {
  final String? groupLogo;
  final String? groupName;

  const ChatPage({required this.groupName, required this.groupLogo, super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // late FlutterSecureStorage storage = const FlutterSecureStorage();
  late SharedPreferences prefs;
  TextEditingController? chatController = TextEditingController();  //for textinput
  final ScrollController _scrollController = ScrollController(); //for scrolling data
  UserModel? user;
  Map<String, List<ChatModel>> chatMap = {};
  bool _isLoadingData = false;
  bool _hasMoreData = true;

  @override
  void initState() {
    getUserDetails();
    getChatHistory();
    _scrollController.addListener(_onScroll);
    // Add listener to update UI when text changes
    chatController?.addListener(() {
      setState(() {}); // Triggers rebuild when text changes
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels <= _scrollController.position.minScrollExtent &&
        !_isLoadingData &&
        _hasMoreData) {
      _loadMoreData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          actions: [
            groupNameLogo(
                context: context,
                groupName: widget.groupName,
                groupLogo: widget.groupLogo,
                onTap: () => nextScreen(context, GroupChatDetails())),
          ],
        ),
        body: user != null
            ? Column(
                children: [
                  Expanded(
                    child: CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        if (_isLoadingData)
                          SliverToBoxAdapter( //loader for fetching chat history
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.only(top: 3),
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.5, // Optional: controls thickness of the indicator
                                  color: secondaryColor,
                                ),
                              ),
                            ),
                          ),
                        ...chatMap.entries.map((entry) {
                          final date = entry.key;
                          final messages = entry.value;
                          
                          return SliverMainAxisGroup(
                            slivers: [
                              SliverPersistentHeader(
                                pinned: true,
                                delegate: ChatDateHeader(
                                  date: date,
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    final message = messages[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 20),
                                      child: message.messageType ==
                                              messageType.message.name
                                          ? user?.phone == message.phone
                                              ? UserSenderWidget(
                                                  message: message.message,
                                                  date: message.date)
                                              : UserReceiveWidget(
                                                  userFirstName:
                                                      message.firstName,
                                                  userLastName:
                                                      message.lastName,
                                                  message: message.message,
                                                  date: message.date)
                                          : Container(
                                              width: 100,
                                              height: 100,
                                              color: Colors.green,
                                              child: Text("notification chat"),
                                            ),
                                    );
                                  },
                                  childCount: messages.length,
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                  Directionality(
                    textDirection: ui.TextDirection.rtl,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 8.0),
                      decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10))),
                      child: Row(
                        children: [
                          chatController?.text != null &&
                                  chatController?.text != ''
                              ? Directionality(
                                  textDirection: ui.TextDirection.ltr,
                                  child: IconButton(
                                      onPressed: () => sendMessage(),
                                      icon: Icon(
                                        Icons.send,
                                        color: whiteColor,
                                      )))
                              : Container(),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: TextFormField(
                              controller: chatController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Message'.tr(),
                                hintStyle: TextStyle(
                                  color: whiteColor,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Center(
                child: CircularProgressIndicator(color: secondaryColor),
              ));
  }

  getUserDetails() async {
    prefs = await SharedPreferences.getInstance();
    String? userStorage = prefs.getString('userInfo');
    if (userStorage != null) {
      // debugPrint("userinfooo: $userStorage");
      final decodedData = jsonDecode(userStorage) as Map<String, dynamic>;
      setState(() {
        user = UserModel.fromJson(decodedData);
      });
    }
  }

  getChatHistory() {
    List<ChatModel> chatHistory = [
      ChatModel(
          id: 1,
          firstName: 'Ali',
          lastName: "Mhd",
          phone: '+96112318238',
          message: "this is my first history!",
          messageType: 'message',
          date: '2025-03-11T13:09:22.123Z'),
      ChatModel(
          id: 2,
          firstName: 'Michel',
          lastName: "Nachar",
          phone: '+9641233322111',
          message: "this is my second history",
          messageType: 'message',
          date: '2025-03-11T13:09:22.123Z'),
      ChatModel(
          id: 1,
          firstName: 'Ali',
          lastName: "Mhd",
          phone: '+96112318238',
          message: "Hello how are you today, all is good?",
          messageType: 'message',
          date: '2025-03-12T13:09:22.123Z'),
      ChatModel(
          id: 2,
          firstName: 'Michel',
          lastName: "Nachar",
          phone: '+9641233322111',
          message: "all is good, what should we predict for today?",
          messageType: 'message',
          date: '2025-03-12T13:09:22.123Z'),
      ChatModel(
          id: 3,
          firstName: 'Samir ali ben abo taleb test test',
          lastName: "Mahmoud",
          phone: '+96112312238',
          message: "are we gonna check the english league?",
          messageType: 'message',
          date: '2025-03-12T13:09:22.123Z'),
      ChatModel(
          id: 1,
          firstName: 'Ali',
          lastName: "Mhd",
          phone: '+96112318238',
          message: "yeah let's start predicting.",
          messageType: 'message',
          date: '2025-03-12T13:09:22.123Z'),
      ChatModel(
          id: 2,
          firstName: 'Michel',
          lastName: "Nachar",
          phone: '+9641233322111',
          message: "i think that liverpool will win!",
          messageType: 'message',
          date: '2025-03-12T13:09:22.123Z'),
      ChatModel(
          id: 3,
          firstName: 'Samir ali ben abo taleb test test',
          lastName: "Mahmoud",
          phone: '+96112312238',
          message: "wait to see ali also",
          messageType: 'message',
          date: '2025-03-12T13:09:22.123Z'),
      ChatModel(
          id: 1,
          firstName: 'Ali',
          lastName: "Mhd",
          phone: '+96112318238',
          message: "ok thats good",
          messageType: 'message',
          date: '2025-03-18T13:09:22.123Z'),
    ];
    setState(() {
      chatMap = _groupMessagesByDate(chatHistory);
    });

    // scrolls the chat list to the bottom (latest message) when a new message is sent
    Future.delayed(Duration(milliseconds: 300), (){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    });
  }

  sendMessage() async {
    //TODO hone kmn bs na3ml websocket lezm a3ml check eza lmsg is success before i show it in the UI
    if (chatController?.text == null || chatController!.text.trim().isEmpty)
      return;

    final newMessage = ChatModel(
        firstName: "${user?.firstName}",
        lastName: "${user?.lastName}",
        phone: "${user?.phone}",
        message: chatController!.text.trim(),
        messageType: messageType.message.name,
        date: DateTime.now().toUtc().toString());

    final dateStr = formatDate(newMessage.date);
    if (!chatMap.containsKey(dateStr)) {
      chatMap[dateStr] = [];
    }
    chatMap[dateStr]!.add(newMessage);

    chatController?.clear();
    setState(() {
      // scrolls the chat list to the bottom (latest message) when a new message is sent
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    });
  }

  Map<String, List<ChatModel>> _groupMessagesByDate(List<ChatModel> chat) {
    final groups = <String, List<ChatModel>>{};

    for (var message in chat) {
      final dateStr = formatDate(message.date); // Use formatted date as key
      if (!groups.containsKey(dateStr)) {
        groups[dateStr] = [];
      }
      groups[dateStr]!.add(message);
    }

    groups.forEach((date, messages) {
      messages.sort(
          (a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));
    });

    return groups;
  }

  Future<void> _loadMoreData() async {
    if (!_hasMoreData) return;

    setState(() {
      _isLoadingData = true;
    });

    // Simulating API call delay
    await Future.delayed(Duration(seconds: 2));

    // TODO: Replace this with your actual API call to get more history
    // If no more data available, set _hasMoreData = false

    setState(() {
      _isLoadingData = false;
    });
  }

}
