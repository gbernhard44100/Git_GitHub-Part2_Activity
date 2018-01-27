<?php


// Chargement des classes
require_once('model/PostManager.php');
require_once('model/CommentManager.php');

function listPosts()
{
    $postManager = new PostManager(); // Création d'un objet
    $posts = $postManager->getPosts(); // Appel d'une fonction de cet objet

    require('view/frontend/listPostsView.php');
}

function post()
{
    $postManager = new PostManager();
    $commentManager = new CommentsManager();

    $post = $postManager->getPost($_GET['id']);
    $comments = $commentManager->getComments($_GET['id']);

    require('view/frontend/postView.php');
}

function addComment($postId, $author, $comment)
{
    $commentManager = new CommentManager();

    $affectedLines = $commentManager->postComment($postId, $author, $comment);

    if ($affectedLines === false) {
        throw new Exception('Impossible d\'ajouter le commentaire !');
    }
    else {
        header('Location: index.php?action=post&id=' . $postId);
    }
}

function reviewComment($commentId)
{       
    $commentManager = new CommentManager();
    $postManager = new PostManager();
    
    $comment_to_review = $commentManager->getComment($commentId);
    $affected_comment = $comment_to_review->fetch();
    
    $post = $postManager->getPost($affected_comment['post_id']);
    $comments = $commentManager->getComment($affected_comment['post_id']);

    require('view/frontend/modifyCommentView.php');
}

function modifyComment($commentId, $author, $comment)
{
    $commentManager = new CommentManager();
    $postManager = new PostManager();
    
    $affectedLines = $commentManager->modifyComment($commentId, $author, $comment);
    
    $modifiedcomment = $commentManager->getComment($commentId);
    $affectedcomment = $modifiedcomment->fetch();

    if ($affectedLines === false) {
        throw new Exception('Impossible de modifier le commentaire !');
    }
    else {
        header('Location: index.php?action=post&id=' . $affectedcomment['post_id']);
    }
}