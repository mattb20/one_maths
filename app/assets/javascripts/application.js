// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require turbolinks
//= require_tree .




function showSolutions() {
  $(document).ready(function() {
    $('.solution-link').show();
    $('.next-question').hide();
    $('.topic-solution-link').show();
    $('.topic-next-question').hide();

    $('.toggle-hide-video').hide();

    $('.chapter-collapsable').next().hide();
    $('.lesson-div').hide();

    $(".topic-headings").css("margin","10px auto");
    $(".lesson-headings").css("margin","6px auto");
    $(".topic-questions-headings").css("margin","6px auto");

    $('.chapter-collapsable').on('click', function(event){
      event.preventDefault();
      if ($(this).next().is(':visible')){
        $(this).next().hide();
      } else {
        $(this).next().show();
      };
      // $(".topic-headings").css("margin","4px auto");
    });

    $('.lesson-collapsable').on('click', function(event){
      event.preventDefault();
      if ($(this).next().is(':visible')){
        $(this).next().hide();
      } else {
        $(this).next().show();
      };
      // $(".lesson-div").css("margin","2px auto");
    });





    // $(".topic-headings").css("margin-top","5px");
    // $(".lesson-headings").css("margin-top","5px");
    // $(".topic-questions-headings").css("margin-top","5px");
    //
    // $('.chapter-collapsable').on('click', function(event){
    //   event.preventDefault();
    //   if ($(this).next().is(':visible')){
    //     $(this).next().hide();
    //   } else {
    //     $(this).next().show();
    //   };
    //   $(".topic-headings").css("margin-top","5px");
    // });
    //
    // $('.lesson-collapsable').on('click', function(event){
    //   event.preventDefault();
    //   if ($(this).next().is(':visible')){
    //     $(this).next().hide();
    //   } else {
    //     $(this).next().show();
    //   };
    //   $(".lesson-div").css("margin-top","5px");
    // });






    $('.toggle-video').on('click', function(event){
      event.preventDefault();
      var linkText = $(this).text();
      if (linkText == 'Show Video') {
        $(this).prev().css("display","");
        $(this).text('');
        $(this).append("<i class='fa fa-arrow-up' aria-hidden='true'></i> Hide Video");
        $(".toggle-hide-video").show();
      } else {
        $(this).prev().css("display","none");
        $(this).text('Show Video');
        $(".toggle-hide-video").hide();
      };
    });


    $('.toggle-hide-video').on('click', function(event){
      event.preventDefault();
      $(this).next().css("display","none");
      $(this).next().next().text('Show Video');
      $(".toggle-hide-video").hide();
    });



    var submitSolution = function(event){
      event.preventDefault();
      var submitSolutionForm = $(this).parent();
      submitSolutionForm.siblings('.next-question').show();
      var postAddress = submitSolutionForm.attr('action');
      var choice = submitSolutionForm.find('input:checked[name="choice"]').val();
      var question_id = submitSolutionForm.find('input[name="question_id"]').val();
      var lesson_id = submitSolutionForm.find('input[name="lesson_id"]').val();
      var authenticity_token = submitSolutionForm.find('input[name="authenticity_token"]').val();
      // var solutionDiv = $(this).siblings("#solution-latex");
      var solutionTitle = $(this).siblings(".solution-title");
      var solutionText = $(this).siblings(".solution-text");
      var correctDiv = $(this).siblings("#correct");
      // var currentLessonExp = $(this).parent().parent().prev().prev(".lesson-headings").children(".lesson-progress-exp").children(".current-lesson-exp").css({"color": "red", "border": "2px solid red"});
      // submitSolutionForm.parent().css({"color": "red", "border": "2px solid red"});

      var lessonExp = submitSolutionForm.parent().prev().prev().prev(".lesson-headings").children(".lesson-progress-exp").children(".current-lesson-exp");
      var topicExp = submitSolutionForm.parent().parent().prev().children(".topic-headings").children(".progress-exp").children(".topic-exp");
      var topicNextLevelExp = submitSolutionForm.parent().parent().prev().children(".topic-headings").children(".progress-exp").children(".next-level-exp");
      var topicNextLevel = submitSolutionForm.parent().parent().prev().children(".topic-headings").children(".progress-exp").children(".next-level");

      $.post(postAddress, { 'choice': choice, 'question_id': question_id, 'lesson_id': lesson_id, 'authenticity_token': authenticity_token }, function(response){
        // solutionDiv.text(response.question_solution);
        solutionTitle.text("Solution");
        solutionText.text(response.question_solution);
        correctDiv.text(response.message);
        lessonExp.text(response.lesson_exp);
        topicExp.text(response.topic_exp);
        topicNextLevelExp.text(response.topic_next_level_exp);
        topicNextLevel.text(response.topic_next_level);

        if (response.choice == "true") {
          correctDiv.css("color", "green");
        } else {
          correctDiv.css("color", "red");
        };
        MathJax.Hub.Typeset();
      });
    };




    $('.solution-link').on('click',submitSolution);





    $('.remove-question').on('click', function(event){
      event.preventDefault();
      var postAddress = $(this)[0].href;
      var authenticity_token = $('meta[name="csrf-token"]').attr("content");
      var question_id = $(this).parent().data("questionid");
      var lesson_id = $(this).parent().data("lessonid");
      var crudDiv = $(this).parent();
      $.post(postAddress, {'question_id': question_id, 'lesson_id': lesson_id, 'authenticity_token': authenticity_token}, function(response){
        crudDiv.siblings(".question-" + question_id).remove();
        crudDiv.remove();
        MathJax.Hub.Typeset();
      });
    });




    $('.next-question').on('click', function(event){
      event.preventDefault();
        var nextQuestionLink = $(this);
        var nextQuestionDiv = $(this).parent('div');
        var nextQuestionForm = $(this).siblings('form');

      $.get(this.href, function(response){

        if (response.question == "") {
          nextQuestionDiv.empty();
          nextQuestionDiv.append("<div class='request-more-questions'>Well done! You have attempted all the questions available for this lesson, contact us to ask for more!</div>")

        } else {


          nextQuestionForm.siblings('.question-header').children('.question-exp').text(response.question.experience);
          nextQuestionForm.siblings('.question-header').children('.streak-mtp').text(response.lesson_bonus_exp);

          nextQuestionDiv.children().eq(1).text(response.question.question_text);
          nextQuestionForm.children().eq(2).val(response.question.id);
          var utfInput = nextQuestionForm.children().eq(0);
          var tokenInput = nextQuestionForm.children().eq(1);
          var questionIdInput = nextQuestionForm.children().eq(2);
          var lessonIdInput = nextQuestionForm.children().eq(3);
          // var solutionLatexDiv = nextQuestionForm.children().last();
          var solutionTitle = nextQuestionForm.children('.solution-title');
          var solutionText = nextQuestionForm.children('.solution-text');
          solutionTitle.text("");
          solutionText.text("");

          nextQuestionForm.children().last().remove();
          nextQuestionForm.children().last().remove();
          var correctDiv = nextQuestionForm.children().last();
          correctDiv.text('');

          nextQuestionForm.children().last().remove();
          var submitInput = nextQuestionForm.children().last();
          nextQuestionForm.children().last().remove();

          nextQuestionForm.empty();

          nextQuestionForm.append(utfInput);
          nextQuestionForm.append(tokenInput);
          nextQuestionForm.append(questionIdInput);
          nextQuestionForm.append(lessonIdInput);
          var choices = response.choices;
          for (var i = 0, len = choices.length; i < len; i++) {
            nextQuestionForm.append("<input class='question-choice' type='radio' id='choice-"
              + choices[i].id +"' " + "name='choice' value=" + choices[i].correct
              +  ">" + '<span style="padding-left:10px;">' + choices[i].content + '</span>' + "<br>");
          };
          nextQuestionForm.append(submitInput);
          nextQuestionForm.append(correctDiv);
          // nextQuestionForm.append(solutionLatexDiv);
          nextQuestionForm.append(solutionTitle);
          nextQuestionForm.append(solutionText);

          nextQuestionLink.hide();
          nextQuestionForm.children('.solution-link').show();
          MathJax.Hub.Typeset();

          $('.solution-link').on('click',submitSolution);


        };





      });
    });










    var submitTopicSolution = function(event){
      event.preventDefault();
      var submitSolutionForm = $(this).parent();
      submitSolutionForm.siblings('.topic-next-question').show();
      var postAddress = submitSolutionForm.attr('action');
      var choice = submitSolutionForm.find('input:checked[name="choice"]').val();
      var question_id = submitSolutionForm.find('input[name="question_id"]').val();
      var topic_id = submitSolutionForm.find('input[name="topic_id"]').val();
      var authenticity_token = submitSolutionForm.find('input[name="authenticity_token"]').val();
      // var solutionDiv = $(this).siblings("#solution-latex");
      var solutionTitle = $(this).siblings(".solution-title");
      var solutionText = $(this).siblings(".solution-text");
      var correctDiv = $(this).siblings("#correct");
      // var currentLessonExp = $(this).parent().parent().prev().prev(".lesson-headings").children(".lesson-progress-exp").children(".current-lesson-exp").css({"color": "red", "border": "2px solid red"});

      var topicExp = submitSolutionForm.parent().prev().children(".progress-exp").children(".topic-exp");
      var topicNextLevelExp = submitSolutionForm.parent().prev().children(".progress-exp").children(".next-level-exp");
      var topicNextLevel = submitSolutionForm.parent().prev().children(".progress-exp").children(".next-level");
      var params = { 'choice': choice, 'question_id': question_id, 'topic_id': topic_id, 'authenticity_token': authenticity_token };

      console.log(params);

      $.post(postAddress, params , function(response){
        // solutionDiv.text(response.question_solution);

        console.log(response);

        solutionTitle.text("Solution");
        solutionText.text(response.question_solution);
        correctDiv.text(response.message);

        topicExp.text(response.topic_exp);
        topicNextLevelExp.text(response.topic_next_level_exp);
        topicNextLevel.text(response.topic_next_level);

        if (response.choice == "true") {
          correctDiv.css("color", "green");
        } else {
          correctDiv.css("color", "red");
        };
        MathJax.Hub.Typeset();
      });
    };




    $('.topic-solution-link').on('click',submitTopicSolution);




    $('.topic-next-question').on('click', function(event){
      event.preventDefault();
        var nextQuestionLink = $(this);
        var nextQuestionDiv = $(this).parent('div');
        var nextQuestionForm = $(this).siblings('form');

      $.get(this.href, function(response){

        if (response.question == "") {
          nextQuestionDiv.empty();
          nextQuestionDiv.append("<div class='request-more-questions'>Well done! You have attempted all the questions available for this chapter, contact us to ask for more!</div>")

        } else {

          nextQuestionForm.siblings('.question-header').children('.question-exp').text(response.question.experience);
          nextQuestionForm.siblings('.question-header').children('.streak-mtp').text(response.topic_bonus_exp);

          nextQuestionDiv.children().eq(1).text(response.question.question_text);
          nextQuestionForm.children().eq(2).val(response.question.id);
          var utfInput = nextQuestionForm.children().eq(0);
          var tokenInput = nextQuestionForm.children().eq(1);
          var questionIdInput = nextQuestionForm.children().eq(2);
          var topicIdInput = nextQuestionForm.children().eq(3);
          // var solutionLatexDiv = nextQuestionForm.children().last();
          var solutionTitle = nextQuestionForm.children('.solution-title');
          var solutionText = nextQuestionForm.children('.solution-text');
          solutionTitle.text("");
          solutionText.text("");

          nextQuestionForm.children().last().remove();
          nextQuestionForm.children().last().remove();
          var correctDiv = nextQuestionForm.children().last();
          correctDiv.text('');

          nextQuestionForm.children().last().remove();
          var submitInput = nextQuestionForm.children().last();
          nextQuestionForm.children().last().remove();

          nextQuestionForm.empty();

          nextQuestionForm.append(utfInput);
          nextQuestionForm.append(tokenInput);
          nextQuestionForm.append(questionIdInput);
          nextQuestionForm.append(topicIdInput);
          var choices = response.choices;
          for (var i = 0, len = choices.length; i < len; i++) {
            nextQuestionForm.append("<input class='question-choice' type='radio' id='choice-"
              + choices[i].id +"' " + "name='choice' value=" + choices[i].correct
              +  ">" + '<span style="padding-left:10px;">' + choices[i].content + '</span>' + "<br>");
          };
          nextQuestionForm.append(submitInput);
          nextQuestionForm.append(correctDiv);
          // nextQuestionForm.append(solutionLatexDiv);
          nextQuestionForm.append(solutionTitle);
          nextQuestionForm.append(solutionText);

          nextQuestionLink.hide();
          nextQuestionForm.children('.topic-solution-link').show();
          MathJax.Hub.Typeset();

          $('.topic-solution-link').on('click',submitTopicSolution);
        };


      });
    });







  });
  MathJax.Hub.Typeset();
};
