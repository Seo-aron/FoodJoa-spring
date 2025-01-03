<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="contextPath" value="${ pageContext.request.contextPath }" />
<c:set var="resourcePath" value="${ contextPath }/resources" />

<c:set var="id" value="admin" />

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>자유게시판 수정</title>

<script src="http://code.jquery.com/jquery-latest.min.js"></script>	
	
<link rel="stylesheet" href="${ resourcePath }/css/community/update.css">

</head>
<body>
	<div id="top_container" align="center">
		<p class="community_p1">COMMUNITY</p>
		<p class="community_p2">자유 게시판</p>
		<p>자유롭게 글을 작성해보세요</p>
	</div>
	<div id="container">
		<div class="form-container">
			<form>
				<div>
					<label for="title">제목</label>
					<input type="text" id="title" name="title" value="${ community.title }">
					
					<label for="contents">내용</label>
					<textarea id="contents" name="contents" rows="25">${ community.contents }</textarea>
					
					<div class="bottom_button" align="center">
						<button onclick="onUpdateButton(event)">수정</button>
						<button onclick="onListButton(event)">목록</button>
					</div>
				</div>	
			</form>
		</div>
	</div>
	
	<script>
		function onUpdateButton(e) {
			e.preventDefault();
			
			$.ajax({
				url: "${contextPath}/Community/updatePro",
				type: "post",
				data: {
					no: ${community.no},
					id: '${id}',
					title: $("#title").val(),
					contents: $("#contents").val(),
					views: ${community.views}
				},
				dataType: "text",
				success: function(responsedData) {
					
					if (responsedData == "1") {
						alert('수정되었습니다');
						location.href = '${contextPath}/Community/read?no=${community.no}';
					}
					else {
						alert('게시글 수정을 실패 했습니다.');
					}
				},
				error: function(error) {
					console.log(error);
				}
			});
		}
	
		function onListButton(e) {
			e.preventDefault();
			location.href='${contextPath}/Community/list';
		}
	</script>
	
</body>
</html>