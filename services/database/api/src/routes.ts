import { Router, Request, Response } from 'express';
import { createUser, getMovies, getUser, getLiked, getDisliked, deleteLike, addLike } from './database-manager';
import { moviesIn, likeInGET, dislikeInGET, likeInDELETE, userInGET, userInPOST, likeInPOST } from './models';

export const router = Router();

router.get('/status', async (req: Request, res: Response): Promise<Response> => {
    return res.status(200).json({ message: 'Database API is running.' });
});

// Retrieve movie(s) information
router.get('/movies', moviesIn, getMovies);

// Retrieve a user's information
router.get('/user', userInGET, getUser);

// Create new user
router.post('/user/create', userInPOST, createUser);

//Get likes
router.get('/liked', likeInGET, getLiked);

//Get dislikes
router.get('/disliked', dislikeInGET, getDisliked);

//Delete likes
router.delete('/liked/delete', likeInDELETE, deleteLike);

//Add likes
router.post('/liked/add', likeInPOST, addLike);