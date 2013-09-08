#pragma once

#include <QObject>
#include <QQueue>
#include <QQuickView>
#include <QPointer>

#include <Spotinetta/Spotinetta>

#include "navigation/navigation.h"

#include "audiooutput.h"

namespace Sonetta {

class Player : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool shuffle READ shuffle WRITE setShuffle NOTIFY shuffleChanged)
    Q_PROPERTY(bool repeat READ repeat WRITE setRepeat NOTIFY repeatChanged)
    Q_PROPERTY(int position READ position NOTIFY positionChanged)
    Q_PROPERTY(Spotinetta::Track track READ track NOTIFY trackChanged)

public:
    explicit Player(Spotinetta::Session * session, AudioOutput * output, QObject *parent = 0);

    bool shuffle() const;
    bool repeat() const;
    int position() const;
    Spotinetta::Track track() const;

    void setShuffle(bool enable);
    void setRepeat(bool enable);
    
signals:
    void shuffleChanged();
    void repeatChanged();
    void trackChanged();
    void positionChanged();
    
public slots:
    void play(const Spotinetta::Track &track);
    void enqueue(const Spotinetta::Track &track);

    void play();
    void playPause();
    void pause();
    void next();

private:
    QPointer<Spotinetta::Session>   m_session;
    QPointer<AudioOutput>           m_output;
    QQueue<Spotinetta::Track>       m_explicitQueue;
    Spotinetta::TrackWatcher *      m_watcher;

    bool m_shuffle;
    bool m_repeat;
};

}
