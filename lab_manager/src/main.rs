use std::io;
use tui::{
    backend::CrosstermBackend,
    widgets::{Block, Borders, List, ListItem},
    Terminal,
    layout::{Layout, Constraint, Direction},
    style::{Style, Color},
};

use crossterm::{
    event::{self, Event, KeyCode},
    execute,
    terminal::{disable_raw_mode, enable_raw_mode, EnterAlternateScreen, LeaveAlternateScreen},
};

fn main() -> Result<(), Box<dyn std::error::Error>> {
    // Setup terminal
    enable_raw_mode()?;
    let mut stdout = io::stdout();
    execute!(stdout, EnterAlternateScreen)?;
    let backend = CrosstermBackend::new(stdout);
    let mut terminal = Terminal::new(backend)?;

    let mut selected = 0;
    let items = vec![
        "Parar docker",
        "Limpiar colima",
        "Levantar lab de cero",
        "Levantar lab (último estado)",
        "Iniciar contenedor",
        "Parar contenedor",
        "Entrar al contenedor",
    ];

    loop {
        terminal.draw(|frame| {
            let size = frame.size();
            let chunks = Layout::default()
                .direction(Direction::Vertical)
                .margin(2)
                .constraints([Constraint::Percentage(80), Constraint::Percentage(20)].as_ref())
                .split(size);

            let list_items: Vec<ListItem> = items
                .iter()
                .enumerate()
                .map(|(i, &name)| {
                    let style = if i == selected {
                        Style::default().fg(Color::Yellow)
                    } else {
                        Style::default()
                    };
                    ListItem::new(name).style(style)
                })
                .collect();

            let list = List::new(list_items).block(Block::default().borders(Borders::ALL).title("HTB LAB"));
            frame.render_widget(list, chunks[0]);
        })?;

        if let Event::Key(key) = event::read()? {
            match key.code {
                KeyCode::Char('q') => break,
                KeyCode::Down => {
                    selected = (selected + 1).min(items.len() - 1);
                }
                KeyCode::Up => {
                    selected = selected.saturating_sub(1);
                }
                KeyCode::Enter => {
                    println!("Ejecutar: {}", items[selected]);
                    break;
                }
                _ => {}
            }
        }
    }

    disable_raw_mode()?;
    execute!(terminal.backend_mut(), LeaveAlternateScreen)?;
    Ok(())
}