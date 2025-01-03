<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=utf-8");
%>

<c:set var="contextPath" value="${ pageContext.request.contextPath }" />
<c:set var="resourcesPath" value="${ contextPath }/resources" />

<c:set var="id" value="${ sessionScope.userId }"/>

<jsp:useBean id="stringParser" class="Common.StringParser" />
<jsp:useBean id="now" class="java.util.Date" />
<fmt:formatDate var="currentDate" value="${now}" pattern="yyyy-MM-dd HH:mm:ss" />
<c:set var="now" value="${currentDate}" />

<c:set var="together" value="${ togetherInfo.together }"/>
<c:set var="member" value="${ together.memberVO }"/>
<c:set var="replies" value="${ togetherInfo.replies }"/>

<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	
	<script src="http://code.jquery.com/jquery-latest.min.js"></script>
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bxslider@4.2.17/dist/jquery.bxslider.min.css">
    <script src="https://cdn.jsdelivr.net/npm/bxslider@4.2.17/dist/jquery.bxslider.min.js"></script>
    <script type="text/javascript" src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpClientId=ug8ym1cpbw&submodules=geocoder"></script>
	
	<link href="https://fonts.googleapis.com/css2?family=Noto+Serif+KR:wght@200..900&display=swap" rel="stylesheet">
	<link rel="stylesheet" href="${ resourcesPath }/css/together/read.css">
	
	<script>        
		$(function() {
			$('.bx_slider').bxSlider({
				adaptiveHeight: true,
				auto : true,
				pager : false
			});
		});
	</script>
</head>

<body>
	<div class="together-container">
		<div class="together-button-area">
			<c:if test="${ not empty id and id != together.id and together.finished == 0 and now <= together.joinDate }">
				<c:choose>
					<c:when test="${ togetherInfo.isExistJoin == 0 }">
						<input type="button" value="모임 참석" onclick="onTogetherJoinButton()">
					</c:when>
					<c:otherwise>
						<input type="button" value="참석 취소" onclick="onJoinCancleButton()">
					</c:otherwise>
				</c:choose>
			</c:if>
			<c:if test="${ not empty id and id == together.id and together.finished == 0 and now <= together.joinDate }">
				<input type="button" value="모임 마감" onclick="onJoinFinishButton()">
			</c:if>
			<input type="button" value="목록" onclick="onListButton()">
			<c:if test="${ not empty id and id == together.id }">
				<input type="button" value="수정" onclick="onEditButton()">
				<input type="button" value="삭제" onclick="onDeleteButton()">
			</c:if>
		</div>
	
		<div class="together-header">
			<hr>
			<ul>
			    <li class="profile-img">
			    	<div>
			        	<img src="${ resourcesPath }/images/member/userProfiles/${ together.id }/${ member.profile }">
			    	</div>
			    </li>
			    <li class="together-title">
			    	<c:choose>
			    		<c:when test="${ now > together.joinDate }">
			    			<span class="join-state-done">종료</span>
		    			</c:when>
			    		<c:when test="${ together.finished == 1 }">
			    			<span class="join-state-finish">모집 마감</span>
			    		</c:when>
			    		<c:otherwise>
			    			<span class="join-state-ing">모집 중</span>
		    			</c:otherwise>
		    		</c:choose>
			    	${ together.title }
			    </li>
			    <li class="together-nickname">
			    	${ member.nickname }
			    </li>
			    <li class="together-views">					        
			        <p>조회수 : ${ together.views }</p>
			    </li>
			</ul>
			<hr>
		</div>
		
		<div class="together-info">		
			<div class="together-pictures">
				<ul class="bx_slider">
					<c:set var="pictures" value="${ stringParser.splitString(together.pictures) }"/>
					<c:forEach var="picture" items="${ pictures }">
						<li>
							<div class="image-area">
								<img src="${ resourcesPath }/images/together/pictures/${ together.no }/${ picture }">
							</div>
						</li>
					</c:forEach>
				</ul>
			</div>
			
			<div class="together-join-info">
				<div class="together-join-date">
					<div class="date-icon">
						<img src="${ resourcesPath }/images/together/date_icon.png">
					</div>
					<span>모임 날짜</span>
					<div><fmt:formatDate value="${ together.joinDate }" pattern="yyyy-MM-dd HH:mm" /></div>
				</div>
				<div class="together-join-place">
					<div class="location-icon">
						<img src="${ resourcesPath }/images/together/location_icon.png">
					</div>
					<span>모임 장소</span>
					<div>${ together.place }</div>
				</div>
				<div class="together-join-people">
					<div class="join-icon">
						<img src="${ resourcesPath }/images/together/join_icon.png">
					</div>
					<span>참여 인원</span>
					<div>${ togetherInfo.joinCount } / ${ together.people }</div>
				</div>
			</div>
		</div>
		
		<div class="together-contents-header">모임 소개</div>
		
		<div class="together-contents">${ together.contents }</div>
		
		<div class="together-map-header">모임 상세 위치</div>
		
		<div class="together-map">
			<div id="map"></div>
		</div>
		
		<div class="together-reply-area">
			<div class="together-reply-count">댓글 (${ replies.size() })</div>
			<c:if test="${ not empty id }">
				<div class="together-reply-input">
					<textarea id="reply-contents"></textarea>
					<input type="button" value="작성" onclick="onReplyEditButton(0, this)">
				</div>
			</c:if>
			
			<c:choose>
				<c:when test="${ empty replies }">
					<div class="reply-nodata">
						작성된 댓글이 없습니다.
					</div>
				</c:when>
				<c:otherwise>
					<div class="together-reply-list">
						<c:forEach var="reply" items="${ replies }">
							<div class="reply-cell">
								<div class="reply-profile">
									<div class="reply-profile-image">
										<img src="${ resourcesPath }/images/member/userProfiles/${ reply.id }/${ reply.memberVO.profile }">
									</div>
									<div class="reply-nickname">
										${ reply.memberVO.nickname }
									</div>
								</div>
								<div class="reply-infos">
									<input type="hidden" class="no" value="${ reply.no }">
									<div class="reply-contents">${ reply.contents }</div>
									<div class="reply-post-date">
										<fmt:formatDate value="${ reply.postDate }" pattern="yyyy-MM-dd a hh:mm"/>
									</div>
									<c:if test="${ reply.id == id }">
										<div class="reply-button-area">
											<input type="button" value="수정" class="reply-update-button" onclick="onReplyUpdateButton(this)">
											<input type="button" value="삭제" class="reply-delete-button" onclick="onReplyDeleteButton(${ reply.no })">
										</div>
									</c:if>
								</div>
							</div>
						</c:forEach>
					</div>
				</c:otherwise>
			</c:choose>
		</div>
		
		<div class="together-button-area">
			<c:if test="${ not empty id and id == together.id }">
				<input type="button" value="수정" onclick="onEditButton()">
				<input type="button" value="삭제" onclick="onDeleteButton()">
			</c:if>
			<input type="button" value="목록" onclick="onListButton()">
		</div>
	</div>
	
	
    <script type="text/javascript" src="${ resourcesPath }/js/common/naverMapAPI.js"></script>
	<script>
		function onJoinFinishButton() {
			if (confirm('모임을 마감하시겠습니까?')) {
				$.ajax({
					url: '${ contextPath }/Together/togetherFinish',
					async: true,
					type: 'get',
					data: {
						no: ${ together.no }
					},
					dataType: 'text',
					success: function(responsedData) {
						if (responsedData == "1") {
							alert('모임을 마감했습니다.');
							location.reload();
						}
						else {
							alert('모임 마감을 실패했습니다.');
						}
					},
					error: function(error) {
						console.log(error);
						alert('모임 마감 중 통신 에러 발생');
					}
				});
			}
		}
	
		function onReplyDeleteButton(no) {
			if (confirm('댓글을 삭제 하시겠습니까?')) {
				$.ajax({
					url: '${ contextPath }/Together/deleteReply',
					async: true,
					type: 'get',
					data: {
						no: no
					},
					dataType: 'text',
					success: function(responsedData) {
						if (responsedData == "1") {
							alert('댓글 삭제가 완료되었습니다.');
							location.reload();
						}
						else {
							alert('댓글 삭제에 실패했습니다.');
						}
					},
					error: function(error) {
						console.log(error);
						alert('댓글 삭제 중 통신 에러 발생');
					}
				});
			}
		}
	
		function onReplyUpdateButton(element) {
			let replyNo = $(element).closest('.reply-infos').find('.no').val();
			
			let updateBtn = $(element);
			let deleteBtn = $(element).next();
			
			let replyContentsDiv = $(element).closest('.reply-infos').find('.reply-contents');
		    let originalContent = replyContentsDiv.text();
		    
		    let textarea = $('<textarea class="reply-edit-textarea"></textarea>');
		    textarea.val(originalContent);
		    replyContentsDiv.replaceWith(textarea);
		    
		    let updateProcessBtn = $('<input type="button" class="reply-update-button" value="작성">').on('click', function() {
		    	onReplyEditButton(replyNo, this);
			});
		    let updateCancleBtn = $('<input type="button" class="reply-delete-button" value="취소">').on('click', function() {
		    	textarea.replaceWith(replyContentsDiv);
		    	updateProcessBtn.replaceWith(updateBtn);
		    	updateCancleBtn.replaceWith(deleteBtn);
			});
		    
		    updateBtn.replaceWith(updateProcessBtn);
		    deleteBtn.replaceWith(updateCancleBtn);
		    
		    textarea.focus();
		}
	
		function onReplyEditButton(no, element) {

			let str = no <= 0 ? '작성' : '수정';
			let replyContents = no <= 0 ? 
					$("#reply-contents").val() :
					$(element).closest('.reply-infos').find('textarea').val();
			
			if (confirm('댓글을 ' + str + '하시겠습니까?')) {
				
				$.ajax({
					url: '${ contextPath }/Together/replyEdit',
					async: true,
					type: 'post',
					data: {
						no: no,
						id: '${ id }',
						togetherNo: ${ together.no },
						contents: replyContents
					},
					dataType: 'text',
					success: function (responsedData) {
						if (responsedData == "1") {
							alert('댓글을 ' + str + '했습니다.');
							location.reload();
						}
						else {
							alert('댓글 ' + str + '에 실패했습니다.');
						}
					},
					error: function(error) {
						console.log(error);
						alert('댓글 ' + str + ' 중 통신 에러 발생');
					}
				});
			}
		}
		
		function onJoinCancleButton() {
			if (confirm('정말로 모임 참석을 취소하시겠습니까?')) {
				$.ajax({
					url: '${ contextPath }/Together/deleteJoin',
					async: true,
					type: 'get',
					data: {
						togetherNo: ${ together.no },
						id: '${ id }'
					},
					dataType: 'text',
					success: function(responsedData) {
						if (responsedData == "1") {
							alert('모임 참석을 취소했습니다.');
							location.reload();
						}
						else {
							alert('모임 참석 취소를 실패했습니다.');
						}
					},
					error: function(error) {
						console.log(error);
						alert('모임 참석 취소 중 통신 에러 발생');
					}
				});
			}
		}
	
		function onTogetherJoinButton() {
			let userId = '${ id }';
			
			if (userId == '') {
				alert('로그인이 필요한 서비스입니다.');
				return;
			}
			
			if (confirm('모임에 참여하시겠습니까?')) {			
				$.ajax({
					url: '${ contextPath }/Together/togetherJoin',
					async: true,
					type: 'get',
					data: {
						no: ${ together.no }
					},
					dataType: 'text',
					success: function(responsedData) {
						if (responsedData == "1") {
							alert('모임에 참석하셨습니다.');
							location.reload();
						}
						else if (responsedData == "2") {
							alert('이미 모임에 참석하셨습니다.');
						}
						else {
							alert('모임 참석 등록에 실패했습니다.');
						}
					},
					error: function(error) {
						console.log(error);
						alert('모임 참석 중 통신 장애 발생');
					}
				});
			}
		}
	
		function onListButton() {
			location.href = '${ contextPath }/Together/list';
		}
	
		function onEditButton() {
			location.href = '${ contextPath }/Together/edit?no=' + ${ together.no };
		}
		
		function onDeleteButton() {
			if (confirm('정말로 삭제하시겠습니까?')) {
				$.ajax({
					url: '${ contextPath }/Together/delete',
					async: true,
					type: 'get',
					data: {
						no: ${ together.no }
					},
					dataType: 'text',
					success: function(responsedData) {
						if (Number(responsedData) > 0) {
							alert('모임이 삭제되었습니다.');
							location.href = '${ contextPath }/Together/list';
						}	
						else {
							alert('모임 삭제에 실패했습니다.');
						}
					},
					error: function(error) {
						console.log(error);
						alert('모임 삭제 중 통신 에러 발생');
					}
				});
			}
		}
	
		function initialize() {
			isRead = true;
			
			let lat = '${ together.lat }';
			let lng = '${ together.lng }';
			
			point = new naver.maps.Point(Number(lng), Number(lat));
			
			searchCoordinateToAddress(point);
		}
		
		window.onload = initialize();
	</script>
</body>

</html>