package com.dbrlwns.classic.recording;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface RecordingRepository extends JpaRepository<Recording, Long> {

    List<Recording> findByWorkId(Long workId);
}
