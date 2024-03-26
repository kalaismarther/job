import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:job/src/core/utils/app_theme.dart';
import 'package:job/src/core/utils/navigation.dart';
import 'package:job/src/features/auth/auth_api.dart';
import 'package:webview_flutter/webview_flutter.dart';

const htmlData =
    "<p>Terms and Conditions</p>\n\n<p>Welcome to Jobs!</p>\n\n<p>These terms and conditions outline the rules and regulations for the use of Jobs&#39;s Website, located at http://13.235.201.81/Jobs.</p>\n\n<p>By accessing this website, we assume you accept these terms and conditions. Do not continue to use Jobsif you do not agree to take all of the terms and conditions stated on this page.</p>\n\n<p>Cookies:</p>\n\n<p>The website uses cookies to help personalize your online experience. By accessing Jobs, you agreed to use the required cookies.</p>\n\n<p>A cookie is a text file that is placed on your hard disk by a web page server. Cookies cannot be used to run programs or deliver viruses to your computer. Cookies are uniquely assigned to you and can only be read by a web server in the domain that issued the cookie to you.</p>\n\n<p>We may use cookies to collect, store, and track information for statistical or marketing purposes to operate our website. You have the ability to accept or decline optional Cookies. There are some required Cookies that are necessary for the operation of our website. These cookies do not require your consent as they always work. Please keep in mind that by accepting required Cookies, you also accept third-party Cookies, which might be used via third-party provided services if you use such services on our website, for example, a video display window provided by third parties and integrated into our website.</p>\n\n<p>License:</p>\n\n<p>Unless otherwise stated, Jobs and/or its licensors own the intellectual property rights for all material on Jobs. All intellectual property rights are reserved. You may access this from Jobs for your own personal use subjected to restrictions set in these terms and conditions.</p>\n\n<p>You must not:</p>\n\n<ul>\n\t<li>Copy or republish material from Jobs</li>\n\t<li>Sell, rent, or sub-license material from Jobs</li>\n\t<li>Reproduce, duplicate or copy material from Jobs</li>\n\t<li>Redistribute content from Jobs</li>\n</ul>\n\n<p>This Agreement shall begin on the date hereof.</p>\n\n<p>Parts of this website offer users an opportunity to post and exchange opinions and information in certain areas of the website. Jobs does not filter, edit, publish or review Comments before their presence on the website. Comments do not reflect the views and opinions of Jobs, its agents, and/or affiliates. Comments reflect the views and opinions of the person who posts their views and opinions. To the extent permitted by applicable laws, Jobs shall not be liable for the Comments or any liability, damages, or expenses caused and/or suffered as a result of any use of and/or posting of and/or appearance of the Comments on this website.</p>\n\n<p>Jobs&nbsp;reserves the right to monitor all Comments and remove any Comments that can be considered inappropriate, offensive, or causes breach of these Terms and Conditions.</p>\n\n<p>You warrant and represent that:</p>\n\n<ul>\n\t<li>You are entitled to post the Comments on our website and have all necessary licenses and consents to do so;</li>\n\t<li>The Comments do not invade any intellectual property right, including without limitation copyright, patent, or trademark of any third party;</li>\n\t<li>The Comments do not contain any defamatory, libelous, offensive, indecent, or otherwise unlawful material, which is an invasion of privacy.</li>\n\t<li>The Comments will not be used to solicit or promote business or custom or present commercial activities or unlawful activity.</li>\n</ul>\n\n<p>You hereby grant Jobs a non-exclusive license to use, reproduce, edit and authorize others to use, reproduce and edit any of your Comments in any and all forms, formats, or media.</p>\n\n<p>Hyperlinking to our Content:</p>\n\n<p>The following organizations may link to our Website without prior written approval:</p>\n\n<ul>\n\t<li>Government agencies;</li>\n\t<li>Search engines;</li>\n\t<li>News organizations;</li>\n\t<li>Online directory distributors may link to our Website in the same manner as they hyperlink to the Websites of other listed businesses; and</li>\n\t<li>System-wide Accredited Businesses except soliciting non-profit organizations, charity shopping malls, and charity fundraising groups which may not hyperlink to our Web site.</li>\n</ul>\n\n<p>These organizations may link to our home page, to publications, or to other Website information so long as the link: (a) is not in any way deceptive; (b) does not falsely imply sponsorship, endorsement, or approval of the linking party and its products and/or services; and (c) fits within the context of the linking party&#39;s site.</p>\n\n<p>We may consider and approve other link requests from the following types of organizations:</p>\n\n<ul>\n\t<li>commonly-known consumer and/or business information sources;</li>\n\t<li>dot.com community sites;</li>\n\t<li>associations or other groups representing charities;</li>\n\t<li>online directory distributors;</li>\n\t<li>internet portals;</li>\n\t<li>accounting, law, and consulting firms; and</li>\n\t<li>educational institutions and trade associations.</li>\n</ul>\n\n<p>We will approve link requests from these organizations if we decide that: (a) the link would not make us look unfavorably to ourselves or to our accredited businesses; (b) the organization does not have any negative records with us; (c) the benefit to us from the visibility of the hyperlink compensates the absence of Jobs; and (d) the link is in the context of general resource information.</p>\n\n<p>These organizations may link to our home page so long as the link: (a) is not in any way deceptive; (b) does not falsely imply sponsorship, endorsement, or approval of the linking party and its products or services; and (c) fits within the context of the linking party&#39;s site.</p>\n\n<p>If you are one of the organizations listed in paragraph 2 above and are interested in linking to our website, you must inform us by sending an e-mail to Jobs. Please include your name, your organization name, contact information as well as the URL of your site, a list of any URLs from which you intend to link to our Website, and a list of the URLs on our site to which you would like to link. Wait 2-3 weeks for a response.</p>\n\n<p>Approved organizations may hyperlink to our Website as follows:</p>\n\n<ul>\n\t<li>By use of our corporate name; or</li>\n\t<li>By use of the uniform resource locator being linked to; or</li>\n\t<li>Using any other description of our Website being linked to that makes sense within the context and format of content on the linking party&#39;s site.</li>\n</ul>\n\n<p>No use of Jobs&#39;s logo or other artwork will be allowed for linking absent a trademark license agreement.</p>\n\n<p>Content Liability:</p>\n\n<p>We shall not be held responsible for any content that appears on your Website. You agree to protect and defend us against all claims that are raised on your Website. No link(s) should appear on any Website that may be interpreted as libelous, obscene, or criminal, or which infringes, otherwise violates, or advocates the infringement or other violation of, any third party rights.</p>\n\n<p>Reservation of Rights:</p>\n\n<p>We reserve the right to request that you remove all links or any particular link to our Website. You approve to immediately remove all links to our Website upon request. We also reserve the right to amend these terms and conditions and its linking policy at any time. By continuously linking to our Website, you agree to be bound to and follow these linking terms and conditions.</p>\n\n<p>Removal of links from our website:</p>\n\n<p>If you find any link on our Website that is offensive for any reason, you are free to contact and inform us at any moment. We will consider requests to remove links, but we are not obligated to or so or to respond to you directly.</p>\n\n<p>We do not ensure that the information on this website is correct. We do not warrant its completeness or accuracy, nor do we promise to ensure that the website remains available or that the material on the website is kept up to date.</p>\n\n<p>Disclaimer:</p>\n\n<p>To the maximum extent permitted by applicable law, we exclude all representations, warranties, and conditions relating to our website and the use of this website. Nothing in this disclaimer will:</p>\n\n<ul>\n\t<li>limit or exclude our or your liability for death or personal injury;</li>\n\t<li>limit or exclude our or your liability for fraud or fraudulent misrepresentation;</li>\n\t<li>limit any of our or your liabilities in any way that is not permitted under applicable law; or</li>\n\t<li>exclude any of our or your liabilities that may not be excluded under applicable law.</li>\n</ul>\n\n<p>The limitations and prohibitions of liability set in this Section and elsewhere in this disclaimer: (a) are subject to the preceding paragraph; and (b) govern all liabilities arising under the disclaimer, including liabilities arising in contract, in tort, and for breach of statutory duty.</p>\n\n<p>As long as the website and the information and services on the website are provided free of charge, we will not be liable for any loss or damage of any nature.</p>\n\n<p>contact us : Jobscustomerhelp@gmail.com</p>";

class TermsConditions extends StatefulWidget {
  const TermsConditions({super.key});

  @override
  State<TermsConditions> createState() => _TermsConditionsState();
}

class _TermsConditionsState extends State<TermsConditions> {
  WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://flutter.dev')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse('https://flutter.dev'));

  var value;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    initilize();
    super.initState();
  }

  initilize() async {
    setState(() {
      isLoading = true;
    });
    // var UserResponse = PrefManager.read("UserResponse");
    var result = await AuthApi.getTermsCondition(context, 0);
    print(result);
    if (result.success) {
      if (result.data['status'].toString() == "1") {
        setState(() {
          // value.addAll(result.data['data']);
          value = result.data['data'];
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.primary,
        title: const Text("Terms and Conditions",
            style: TextStyle(
              color: AppTheme.white,
            )),
        leading: IconButton(
            onPressed: () {
              Nav.back(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppTheme.white,
            )),
      ),
      body:
          // SizedBox(
          //     width: 500,
          //     height: 1000,
          //     child: WebViewWidget(controller: controller))
          !isLoading
              ? SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Html(data: value ?? ""),
                  ),
                )
              : Center(
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
    );
  }
}
