package com.foodjoa.together.vo;

import java.sql.Timestamp;

import org.springframework.stereotype.Component;

import com.foodjoa.member.vo.MemberVO;

import lombok.Data;

@Data
@Component
public class TogetherVO {
	
	private int no;
	private String id;
	private String title;
	private String contents;
	private String pictures;
	private double lat;
	private double lng;
	private Timestamp joinDate;
	private String place;
	private int people;
	private int finished;
	private int views;
	private Timestamp postDate;
	
	private int replyCount;
	
	private MemberVO memberVO;
}	
