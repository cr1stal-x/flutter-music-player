package Services;

import Repositories.GenreRepository;
import models.Genre;

public class GenreService {

    public boolean addGenre(Genre genre) {
        if (!GenreRepository.checkGenreExists(genre)) {
            return GenreRepository.addGenre(genre);
        } else {
            System.out.println("Genre already exists.");
            return false;
        }
    }

    public boolean genreExists(Genre genre) {
        return GenreRepository.checkGenreExists(genre);
    }

    public Genre[] getAllGenres() {
        return GenreRepository.getGenresList();
    }

    public Genre getGenreByName(String name) {
        return GenreRepository.getGenreByName(name);
    }

    public Genre getGenreById(int genreId) {
        return GenreRepository.getGenreById(genreId);
    }
}
